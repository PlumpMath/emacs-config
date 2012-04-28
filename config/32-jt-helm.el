(add-to-list 'load-path (concat thirdparty-dir "helm/"))
(require 'helm-config)
(require 'helm-net) ; google
(require 'helm-regexp)
(require 'helm-misc) ; helm narrowing by default

(global-set-key (kbd "C-x h") 'helm-mini)

(defalias 'regexp 'helm-regexp)
(defalias 'mark-ring 'helm-mark-ring)
(defalias 'kill-ring 'helm-kill-ring)
(defalias 'apropos 'helm-c-apropos)
(defalias 'top 'helm-top)
(defalias 'ucs 'helm-ucs)
(defalias 'colors 'helm-colors)
(defalias 'calculator 'helm-calculator)

;; Hack to prevent helm from complaining
;(setq helm-mode-line-string "")

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
         (hlstr (substring hlstr 0 (min (length hlstr) (window-width))))
         (hlend (make-string (- (window-width) (length hlstr)) ? )))
    (setq header-line-format
          (propertize (concat " " hlstr hlend) 'face 'helm-header))))

