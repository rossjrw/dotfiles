## GPG keys

Get the secret key file, as created by `gpg --export-secret-keys`.

Import it: `gpg --import <keyfile>`

Trust the key: `gpg --edit-key <ref>` (tab-complete will get it) then `trust`

## Firefox config

The default Firefox settings for touchpad are crap. In about:config:

- Change `apz.gtk.pangesture.delta_mode` from 0 to 2 (not super sure what this does but it feels better)
- Change `apz.gtk.pangesture.pixel_delta_mode_multiplier` from 40 to 15 (reduce sensitivity)
- Change `apz.fling_friction` from 0.002 to 0.008 (reduce momentum distance)

## Fractional scaling

If you're using Gnome and if it's still an experimental feature, enable it:

```
gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"
```

It might make the cursor overwhelmingly huge, in which case:

```
gsettings set org.gnome.desktop.interface cursor-size 14
```

If VSCode is subsequently blurry:

- Copy `/usr/share/applications/code.desktop` to `~/.local/share/applications/` (https://askubuntu.com/q/610474/659275)
- Edit the new file and append `--enable-ozone --ozone-platform=wayland` to the commands. (https://www.reddit.com/r/Fedora/comments/wpkws3/comment/ikhc12o/)
- Log out, log in, launch VSCode

## Disable auto brightness

If screen brightness keeps changing based on screen content (not ambient light level), `systemctl edit power-profiles-daemon.service` and add the following, then `systemctl restart power-profiles-daemon.service`:

```
[Service]
ExecStart=
ExecStart=/usr/libexec/power-profiles-daemon --block-action=amdgpu_panel_power
```

Source: https://community.frame.work/t/screen-brightness-automatically-changing/8138/15

