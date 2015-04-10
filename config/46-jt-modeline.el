;; Mode line must come last, depends on some packages setting mode vars

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

    ; Show custom flycheck mode
    (propertize " ["  'face 'font-lock-type-face)
    flycheck-mode-line
    (propertize "] "  'face 'font-lock-type-face)

    ;'(:eval (propertize (flycheck-mode-line-status-text) 'face 'font-lock-type-face))

    ;; minor-mode-alist

    ;; fill with '-'
    (propertize "%-"  'face 'font-lock-type-face)
    ))
