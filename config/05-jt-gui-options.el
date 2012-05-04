;; Turn off menus and tool bars and startup screen
(dolist (mode '(menu-bar-mode tool-bar-mode scroll-bar-mode tooltip-mode))
  (when (fboundp mode) (funcall mode -1)))
(setq inhibit-startup-screen t)
(setq help-at-pt-display-when-idle '(kbd-help))
(setq help-at-pt-timer-delay 0.1)
(help-at-pt-set-timer)

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
(setq linum-format "%3d ")
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
                        python-mode-hook
                        )
                      'turn-rainbow-mode-on)

;; match paren colors
(add-to-list 'load-path (concat thirdparty-dir "rainbow-delimiters/"))
(require 'rainbow-delimiters)
(setup-multiple-hooks '(lisp-mode-hook
                        emacs-lisp-mode-hook
                        text-mode-hook
                        c-mode-common-hook
                        python-mode-hook
                        )
                      'rainbow-delimiters-mode)

(setq frame-title-format
      '("" invocation-name " - " (:eval (if (buffer-file-name)
                                            (abbreviate-file-name (buffer-file-name))
                                          "%b"))))

;; mode line fixes from http://emacs-fu.blogspot.com/2011/08/customizing-mode-line.html
(setq-default mode-line-format
  (list
    (propertize "  " 'face 'font-lock-type-face)
    '(:eval (propertize "%b " 'face 'font-lock-keyword-face
                        'help-echo (buffer-file-name)))

    ;; line and column
    (propertize "(" 'face 'font-lock-type-face) ;; '%02' to set to 2 chars at least; prevents flickering
    (propertize "%02l" 'face 'font-lock-type-face)
    (propertize "," 'face 'font-lock-type-face)
    (propertize "%02c" 'face 'font-lock-type-face)
    (propertize ") " 'face 'font-lock-type-face)

    ;; relative position, size of file
    (propertize "[" 'face 'font-lock-type-face)
    (propertize "%p" 'face 'font-lock-constant-face) ;; % above top
    (propertize "/" 'face 'font-lock-type-face)
    (propertize "%I" 'face 'font-lock-constant-face) ;; size
    (propertize "] " 'face 'font-lock-type-face)

    ;; the current major mode for the buffer.
    (propertize "[" 'face 'font-lock-type-face)

    '(:eval (propertize "%m" 'face 'font-lock-string-face
              'help-echo buffer-file-coding-system))
    (propertize "] " 'face 'font-lock-type-face)


    (propertize "["  'face 'font-lock-type-face)
    ;; was this buffer modified since the last save?
    '(:eval (when (buffer-modified-p)
              (propertize "Mod"
                          'face 'font-lock-warning-face
                          'help-echo "Buffer has been modified")))

    ;; is this buffer read-only?
    '(:eval (when buffer-read-only
              (concat (propertize "," 'face 'font-lock-type-face)
                      (propertize "RO"
                                  'face 'font-lock-type-face
                                  'help-echo "Buffer is read-only"))))
    (propertize "] " 'face 'font-lock-type-face)

    ;; add the time, with the date and the emacs uptime in the tooltip
    '(:eval (propertize (format-time-string "%H:%M")
                        'face 'font-lock-type-face
                        'help-echo
                        (concat (format-time-string "%c; ")
                                (emacs-uptime "Uptime:%hh"))))
    (propertize " --" 'face 'font-lock-type-face)

    ;; minor-mode-alist
    ;; fill with '-'
    (propertize "%-"  'face 'font-lock-type-face)
    ))
