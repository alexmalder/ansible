#!/bin/bash sudo apk add flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install com.visualstudio.code
flatpak install md.obsidian.Obsidian
