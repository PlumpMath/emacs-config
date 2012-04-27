(add-to-list 'load-path (concat thirdparty-dir "helm/"))
(require 'helm-config)

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
  (let* ((hlstr (substring 
                 (helm-interpret-value
                  (assoc-default 'header-line source) source)
                 0 (window-width)))
         (hlend (make-string (- (window-width) (length hlstr)) ? )))
    (setq header-line-format
          (propertize (concat " " hlstr hlend) 'face 'helm-header))))
