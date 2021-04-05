#!/usr/bin/python3


async def generate(hub, **pkginfo):
    project_id = "15323316"
    tag_data = await hub.pkgtools.fetch.get_page(f"https://gitlab.com/api/v4/projects/{project_id}/repository/tags", is_json=True)
    target_tag = tag_data[0]
    tag_name = target_tag["name"].lstrip("kali/")
    print(target_tag)
    ebuild = hub.pkgtools.ebuild.BreezyBuild(
        **pkginfo,
        version=tag_name,
        artifacts=[hub.pkgtools.ebuild.Artifact(url=f"https://gitlab.com/kalilinux/packages/kali-undercover/-/archive/kali/{tag_name}/kali-undercover-kali-{tag_name}.tar.gz")],
    )
    ebuild.push()
