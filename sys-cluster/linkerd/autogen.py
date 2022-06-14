#!/usr/bin/env python


async def tag_generator(hub, github_user, github_repo):
    page = 0
    while True:
        tags = await hub.pkgtools.fetch.get_page(
            f"https://api.github.com/repos/{github_user}/{github_repo}/tags?page={page}&per_page=100",
            is_json=True,
        )

        if not tags:
            break

        for tag in tags:
            if not tag["name"].startswith("stable-"):
                continue

            tag["name"] = tag["name"].lstrip("stable-")

            yield tag

        page += 1


async def generate(hub, **pkginfo):
    github_user = "linkerd"
    github_repo = "linkerd2"

    tag_data = [tag async for tag in tag_generator(hub, github_user, github_repo)]

    latest_tag = await hub.pkgtools.github.tag_gen(hub, github_user, github_repo, tag_data=tag_data)
    pkginfo.update(latest_tag)

    golang_artifacts = await hub.pkgtools.golang.generate_gosum_from_artifact(pkginfo["artifacts"][0])
    pkginfo["artifacts"].extend(golang_artifacts["gosum_artifacts"])

    ebuild = hub.pkgtools.ebuild.BreezyBuild(
        **pkginfo,
        github_user=github_user,
        github_repo=github_repo,
        gosum=golang_artifacts["gosum"],
    )
    ebuild.push()
