# Brian's dotfiles
Still very much a messy work in progress.

Installable with stow (https://www.gnu.org/software/stow/).





## VIM:
vim-plug. 
pretty straightfoward eye-candy-ified setup.
will document and organize someday...

## ZSH:
Antibody for plugins
will document and organize someday

## KITTY:
pretty basic

## VIVALDI:
css to combine taskbar with address bar
enable with settings->custom ui modifications

## FIREFOX: 
[Simplerent Fox](https://github.com/MiguelRAvila/SimplerentFox)
[Oneline Proton](https://github.com/lr-tech/OnelineProton/)
Modified to show current tab & include close button on tabs

### Vimium

The default Vimium theme is a little ugly. 
Here's a better one:

```css
#vimiumHintMarkerContainer div.internalVimiumHintMarker, #vimiumHintMarkerContainer div.vimiumHintMarker {
  padding: 3px 4px;
  background: #444;
  border: none;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.12), 0 1px 2px rgba(0, 0, 0, 0.24);
}

#vimiumHintMarkerContainer div span {
  color: #fff;
  text-shadow: none;
}

#vimiumHintMarkerContainer div > .matchingCharacter {
  opacity: 0.4;
}

#vimiumHintMarkerContainer div > .matchingCharacter ~ span {
  color: hotpink;
}

#vomnibar {
  background: #444;
  border: none;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.12), 0 1px 2px rgba(0, 0, 0, 0.24);
  animation: show 200ms cubic-bezier(0, 0, 0.2, 1) forwards;
}

@keyframes show {
  0% {
    transform: translateY(50px);
    opacity: 0;
  }
  100% {
    transform: translateY(0);
    opacity: 1;
  }
}

#vomnibar .vomnibarSearchArea,
#vomnibar input {
  color: #fff;
  background: transparent;
  border: none;
}

#vomnibar .vomnibarSearchArea {
  padding: 10px 30px;
}

#vomnibar input {
  padding: 0;
}

#vomnibar ul {
  padding: 0;
  background: #444;
  border-top: 1px solid #333;
}

#vomnibar li {
  padding: 10px;
  border-bottom: 1px solid #333;
}

#vomnibar li .vomnibarTopHalf,
#vomnibar li .vomnibarBottomHalf {
  padding: 3px 0;
}

#vomnibar li .vomnibarSource {
  color: #aaa;
}

#vomnibar li em,
#vomnibar li .vomnibarTitle {
  color: #aaa;
}

#vomnibar li .vomnibarUrl {
  color: #777;
}

#vomnibar li .vomnibarMatch {
  color: hotpink;
  font-weight: normal;
}

#vomnibar li .vomnibarTitle .vomnibarMatch {
  color: hotpink;
}

#vomnibar li.vomnibarSelected {
  background-color: #333;
}

div.vimiumHUD {
  background: #444;
  border: none;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.12), 0 1px 2px rgba(0, 0, 0, 0.24);
}

div.vimiumHUD span#hud-find-input,
div.vimiumHUD .vimiumHUDSearchAreaInner {
  color: #fff;
}

div.vimiumHUD .hud-find {
  background-color: transparent;
  border: none;
}

div.vimiumHUD .vimiumHUDSearchArea {
  background-color: transparent;
}
```




## Wallpapers:
a bunch of pretty pictures.






