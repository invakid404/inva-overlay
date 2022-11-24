#!/usr/bin/env python3

import json
from datetime import datetime, timedelta


async def query_github_api(user, repo, query):
    return await hub.pkgtools.fetch.get_page(
        f"https://api.github.com/repos/{user}/{repo}/{query}",
        is_json=True,
        refresh_interval=timedelta(days=3),
    )


async def is_safe(user, repo, commit):
    commit_sha = commit["sha"]
    ci_runs = await query_github_api(
        user, repo, f"actions/workflows/build.yml/runs?event=push&head_sha={commit_sha}"
    )

    if ci_runs["total_count"] <= 0:
        return false

    assert (
        ci_runs["total_count"] == 1
    ), f"got multiple CI runs for {commit_sha}, expected only one"

    workflow_run = ci_runs["workflow_runs"][0]

    return (
        workflow_run["status"] == "completed"
        and workflow_run["conclusion"] == "success"
    )


async def generate(hub, **pkginfo):
    github_user = "helix-editor"
    github_repo = pkginfo["name"]

    release_data = await hub.pkgtools.github.release_gen(
        hub, github_user, github_repo, tarball="helix-{version}-source.tar.xz"
    )

    commits = await query_github_api(github_user, github_repo, "commits")
    safe_commits = (
        commit for commit in commits if await is_safe(github_user, github_repo, commit)
    )

    target_commit = await safe_commits.__anext__()
    commit_hash = target_commit["sha"]
    commit_date = datetime.strptime(
        target_commit["commit"]["committer"]["date"], "%Y-%m-%dT%H:%M:%SZ"
    )

    version = release_data["version"] + "." + commit_date.strftime("%Y%m%d")

    source_url = (
        f"https://github.com/{github_user}/{github_repo}/archive/{commit_hash}.tar.gz"
    )
    final_name = f"{pkginfo['name']}-{version}-{commit_hash}.tar.gz"

    source_artifact = hub.pkgtools.ebuild.Artifact(
        url=source_url, final_name=final_name
    )

    crates_data = await hub.pkgtools.rust.generate_crates_from_artifact(source_artifact)

    ebuild = hub.pkgtools.ebuild.BreezyBuild(
        **pkginfo,
        github_user=github_user,
        github_repo=github_repo,
        commit_hash=commit_hash,
        version=version,
        artifacts=[source_artifact, *crates_data["crates_artifacts"]],
        crates=crates_data["crates"],
    )
    ebuild.push()
