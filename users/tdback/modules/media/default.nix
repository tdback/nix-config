# users/tdback/modules/media/default.nix
#
# For the occasional screen capture to demo a project, or to make simple edits
# on photos and videos.

{
  pkgs,
  ...
}:
{
  home.packages = with pkgs.unstable; [
    davinci-resolve
    (ffmpeg.override { withXcb = true; })
    imagemagick
  ];
}
