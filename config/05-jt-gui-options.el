;; Turn off menus and tool bars and startup screen
(dolist (mode '(menu-bar-mode tool-bar-mode scroll-bar-mode tooltip-mode))
  (when (fboundp mode) (funcall mode -1)))
(setq inhibit-startup-screen t)

;; Disambiguate buffers with the same name by adding the parent director(ies)
(require 'uniquify)
(setq uniquify-separator "/")
(setq uniquify-buffer-name-style 'forward)
(setq uniquify-after-kill-buffer-p t)    ; rename after killing uniquified
(setq uniquify-ignore-buffers-re "^\\*") ; don't muck with special buffers

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
(defun turn-linum-on ()
  (linum-mode))
(add-hook 'python-mode-hook 'turn-linum-on)


(setq background-color (face-attribute 'default :background))
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

(defun update-split-width-thresh ()
  (setq split-width-threshold (max split-width-threshold (min (- (window-width) 10) 160))))
(setq split-width-threshold 0)
(update-split-width-thresh)
(add-hook 'window-configuration-change-hook 'update-split-width-thresh)

; Nicer scrolling
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

; cool colors like #11a2ff #11ff81
(defun turn-rainbow-mode-on ()
  (rainbow-mode +1))
(setup-multiple-hooks '(lisp-mode-hook
                        emacs-lisp-mode-hook
                        text-mode-hook
                        c-mode-common-hook
                        python-mode-hook)
                      'turn-rainbow-mode-on)

(require 'rainbow-delimiters)
(setup-multiple-hooks '(lisp-mode-hook
                        emacs-lisp-mode-hook
                        text-mode-hook
                        c-mode-common-hook
                        python-mode-hook)
                      'rainbow-delimiters-mode)

(setq frame-title-format
      '("" invocation-name " - " (:eval (if (buffer-file-name)
                                            (abbreviate-file-name (buffer-file-name))
                                          "%b"))))
