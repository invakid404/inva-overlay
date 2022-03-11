#!/usr/bin/env python


async def generate(hub, **pkginfo):
	github_user = "caddyserver"
	github_repo = pkginfo["name"]

	latest_release = await hub.pkgtools.github.release_gen(hub, github_user, github_repo)

	golang_deps = await hub.pkgtools.golang.generate_gosum_from_artifact(latest_release["artifacts"][0])

	ebuild = hub.pkgtools.ebuild.BreezyBuild(
		**pkginfo,
		version=latest_release["version"],
		github_user=github_user,
		github_repo=github_repo,
		gosum=golang_deps["gosum"],
		artifacts=[*latest_release["artifacts"], *golang_deps["gosum_artifacts"]],
	)
	ebuild.push()
