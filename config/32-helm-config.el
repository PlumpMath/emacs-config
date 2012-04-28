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
  (let* ((hlstr (helm-interpret-value
                  (assoc-default 'header-line source) source))
         (hlstr (substring hlstr 0 (min (length hlstr) (window-width))))
         (hlend (make-string (- (window-width) (length hlstr)) ? )))
    (setq header-line-format
          (propertize (concat " " hlstr hlend) 'face 'helm-header))))

(require 'helm-elisp)
(defun helm-c-apropos ()
  "Preconfigured helm to describe commands, functions, variables and faces."
  (interactive)
  (let ((default (thing-at-point 'symbol)))
    (helm :buffer "*helm apropos*"
          :sources
          `(((name . "Commands")
             (init . (lambda ()
                       (helm-c-apropos-init 'commandp ,default)))
             (persistent-action . helm-lisp-completion-persistent-action)
             (persistent-help . "Show brief doc in mode-line")
             (candidates-in-buffer)
             (action . (lambda (candidate)
                         (describe-function (intern candidate)))))
            ((name . "Functions")
             (init . (lambda ()
                       (helm-c-apropos-init #'(lambda (x) (and (fboundp x)
                                                               (not (commandp x))))
                                            ,default)))
             (persistent-action . helm-lisp-completion-persistent-action)
             (persistent-help . "Show brief doc in mode-line")
             (candidates-in-buffer)
             (action . (lambda (candidate)
                         (describe-function (intern candidate)))))
            ((name . "Variables")
             (init . (lambda ()
                       (helm-c-apropos-init 'boundp ,default)))
             (persistent-action . helm-lisp-completion-persistent-action)
             (persistent-help . "Show brief doc in mode-line")
             (candidates-in-buffer)
             (action . (lambda (candidate)
                         (describe-variable (intern candidate)))))
            ((name . "Faces")
             (init . (lambda ()
                       (helm-c-apropos-init 'facep ,default)))
             (persistent-action . helm-lisp-completion-persistent-action)
             (persistent-help . "Show brief doc in mode-line")
             (candidates-in-buffer)
             (filtered-candidate-transformer . (lambda (candidates source)
                                                 (loop for c in candidates
                                                       collect (propertize c 'face (intern c)))))
             (action . (lambda (candidate)
                         (describe-face (intern candidate)))))
            ((name . "Helm attributes")
             (candidates . (lambda ()
                             (mapcar 'symbol-name helm-additional-attributes)))
             (action . (lambda (candidate)
                         (with-output-to-temp-buffer "*Help*"
                           (princ (get (intern candidate) 'helm-attrdoc))))))))))
