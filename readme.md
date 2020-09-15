# Kyzenred
A full KDE theme based on gamer aesthetics and modern minimalism (Plasma look-and-feel component)

![Kyzenred Preview](https://github.com/MiiMii1205/kyzenred-sddm/blob/master/preview.png?raw=true)

## Dependencies
- KDE >= 5
- SDDM >= 0.18

## Installation
Just put this repository in `/usr/share/sddm/theme`. For the theme to work correctly you'll also need to fetch every other Kyzenred components.

## Configuration ##

Here's a short list of every possible options found in the theme.config file:

- `fontSize` : the size of the current font
- `font` : the name of the used font
- `blur` : toggles blurring
- `PasswordFieldPlaceholderText` : a hardcoded placeholder text. For multilangual support I recomend kepping the original value
- `useDefaultWallpaper` : toggles the default background. If this is `false`, then if the current user doesn't have any desktop background set then a solid color background will be used instead of the default background
- `background`: The default background to use. Will only show up if `useDefaultWallpaper` is set to `true`
- `PasswordFieldCharacter` : a character that will be used to display password instead of the traditional median dot. 

