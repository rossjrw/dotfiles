## GPG keys

Get the secret key file, as created by `gpg --export-secret-keys`.

Import it: `gpg --import <keyfile>`

Trust the key: `gpg --edit-key <ref>` (tab-complete will get it) then `trust`

## Firefox config

The default Firefox settings for touchpad are crap. In about:config:

- Change `apz.gtk.pangesture.delta_mode` from 0 to 2
- Change `apz.gtk.pangesture.pixel_delta_mode_multiplier` from 40 to 15

## Fractional scaling

If you're using Gnome and if it's still an experimental feature, enable it:

```
gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"
```

It might make the cursor overwhelmingly huge, in which case:

```
gsettings set org.gnome.desktop.interface cursor-size 14
```
