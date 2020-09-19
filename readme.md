# Kyzenred
A full KDE theme based on gamer aesthetics and modern minimalism (SDDM greeter component)

![Kyzenred Preview](https://github.com/MiiMii1205/kyzenred-sddm/blob/master/preview.png?raw=true)

## Dependencies
- KDE >= 5
- SDDM >= 0.18

## Installation
Just put this repository in `/usr/share/sddm/theme`. For the theme to work correctly you'll also need to fetch every other Kyzenred components.

SDDM needs to have additional permissions to fetch your settings and your current color scheme. To enable this, just run the `/scripts/enable-theme.sh` script while connected. Each users have to explicitly run this script, otherwise the default background and color scheme will be used. 

Should you ever want to revoke these permission. just run the `/scripts/disable-theme.sh` script.

Please note that not every background plugins types are supported. The only supported background plugins as of yet are the picture of the day plugin, the image plugin and the color plugin.

## Configuration ##

Here's a short list of every possible options found in the theme.config file:

- `fontSize` : the size of the current font (in points)
- `font` : the name of the used font 
- `blur` : toggles blurring
- `baseAnimationSpeed` : the base animation speed in milliseconds
- `backgroundClock` : controls whenever or not the background clock is displayed
- `passwordFieldPlaceholderText` : a hardcoded placeholder text. For multilingual support I recommend keeping the original value
- `useDefaultWallpaper` : toggles the default background. If this is `false`, then if the current user doesn't have any desktop background set then a solid color background will be used instead of the default background
- `background`: The default background to use. Will only show up if `useDefaultWallpaper` is set to `true`
- `passwordFieldCharacter` : a character that will be used to display password instead of the traditional median dot. 

