(add-to-list 'load-path (concat thirdparty-dir "helm/"))
(require 'helm-config)
(require 'helm-net) ; google
(require 'helm-regexp)
(require 'helm-misc) ; helm narrowing by default

(defun helm-custom ()
  "`helm' with buffers, recentf, files in folder, recent files, bookmarks."
  (interactive)
  (helm :sources '(helm-c-source-buffers-list
                   helm-c-source-bookmarks
                   helm-c-source-files-in-current-dir
                   helm-c-source-file-name-history
                   helm-c-source-recentf
                   helm-c-source-buffer-not-found)
        :buffer "*helm custom*"
        :input (entity-at-point)))

(global-set-key (kbd "C-x C-h") 'helm-custom)
(global-set-key (kbd "C-x h") 'helm-resume)

(defun helm-etags-select (arg)
  "Preconfigured helm for etags.
Called with one prefix arg use symbol at point as initial input.
Called with two prefix arg reinitialize cache.
If tag file have been modified reinitialize cache."
  (interactive "P")
  (let ((tag  (helm-c-etags-get-tag-file))
        (init (entity-at-point))
        (helm-quit-if-no-candidate t)
        (helm-execute-action-at-once-if-one t))
    (when (and helm-c-etags-mtime-alist
               (helm-c-etags-file-modified-p tag))
      (remhash tag helm-c-etags-cache))
    (if (and tag (file-exists-p tag))
        (helm :sources 'helm-c-source-etags-select
              :keymap helm-c-etags-map
              :input init
              :buffer "*helm etags*")
        (message "Error: No tag file found, please create one with etags shell command."))))
(global-set-key (kbd "M-,") 'helm-etags-select)

(defalias 'regexp 'helm-regexp)
(defalias 'mark-ring 'helm-mark-ring)
(defalias 'kill-ring 'helm-kill-ring)
(defalias 'apropos 'helm-c-apropos)
(defalias 'top 'helm-top)
(defalias 'ucs 'helm-ucs)
(defalias 'colors 'helm-colors)
(defalias 'calculator 'helm-calculator)

;; Hack for helm screens shorter than mode line width
(defun helm-display-mode-line (source)
  "Setup mode-line and header-line for `helm-buffer'."
  (set (make-local-variable 'helm-mode-line-string)
       (helm-interpret-value (or (assoc-default 'mode-line source)
                                 (default-value 'helm-mode-line-string))
                             source))
  ;; Setup mode-line.
  (if helm-mode-line-string
      (setq mode-line-format
            '(" " mode-line-buffer-identification " "
              (line-number-mode "L%l") " " (helm-follow-mode "(HF) ")
              (:eval (helm-show-candidate-number
                      (when (listp helm-mode-line-string)
                        (car helm-mode-line-string))))
              " " helm-mode-line-string-real " -%-")
            helm-mode-line-string-real
            (substitute-command-keys (if (listp helm-mode-line-string)
                                         (cadr helm-mode-line-string)
                                         helm-mode-line-string)))
      (setq mode-line-format (default-value 'mode-line-format)))
  ;; Setup header-line.
  (let* ((hlstr (helm-interpret-value
                  (assoc-default 'header-line source) source))
         (hlstr (if hlstr (substring hlstr 0 (min (length hlstr) (window-width))) hlstr))
         (hlend (make-string (- (window-width) (length hlstr)) ? )))
    (setq header-line-format
          (propertize (concat " " hlstr hlend) 'face 'helm-header))))

