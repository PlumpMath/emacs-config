;; Turn off menus and tool bars and startup screen
(dolist (mode '(menu-bar-mode tool-bar-mode scroll-bar-mode tooltip-mode))
  (when (fboundp mode) (funcall mode -1)))
(setq inhibit-startup-screen t)

;; Disambiguate buffers with the same name by adding the parent director(ies)
(require 'uniquify)
(setq uniquify-separator "/")
(setq uniquify-buffer-name-style 'forward)

; don't pop up a file dialog
(setq use-file-dialog nil)

; don't pop up dialog boxes
(setq use-dialog-box nil)

; say y or n instead of yes or no for prompts
(fset 'yes-or-no-p 'y-or-n-p)

; show line number in mode line
(line-number-mode 1)

;; Line numbering
(setq linum-format "%d ")
(global-linum-mode 1)

(setq background-color (cdr (assoc :background (face-all-attributes 'default))))
(set-face-background 'linum background-color)

;; Fringe color
(set-fringe-style '(0 . 4))
(set-face-background 'fringe background-color)


; show column number in mode line
(column-number-mode 1)

; show file name in frame title
(when window-system
  (setq frame-title-format '(buffer-file-name "%f" ("%b"))))

; turn off visible bell
(setq visible-bell nil)

; Prefer horizontal split
(setq split-height-threshold nil)
(setq split-width-threshold 80)


; Nicer scrolling
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

; cool colors like #1122ff
(rainbow-mode 1)

