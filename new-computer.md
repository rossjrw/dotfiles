## Firefox config

## Fractional scaling

If you're using Gnome and if it's still an experimental feature, enable it:

```
gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"
```

It might make the cursor overwhelmingly huge, in which case:

```
gsettings set org.gnome.desktop.interface cursor-size 14
```
