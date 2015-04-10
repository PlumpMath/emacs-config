;; flyspell-mode does spell-checking on the fly as you type
(setq ispell-program-name "aspell" ; use aspell instead of ispell
      ispell-extra-args '("--sug-mode=ultra"))
(autoload 'flyspell-mode "flyspell" "On-the-fly spelling checker." t)

(defun turn-on-flyspell()
  (interactive)
  (flyspell-mode 1))
(add-hook 'text-mode-hook 'turn-on-flyspell)


(add-hook 'after-init-hook #'global-flycheck-mode)

; Also useful: flycheck-list-errors and flycheck-verify-setup
(define-key global-map (kbd "M-n") 'flycheck-next-error)
(define-key global-map (kbd "M-p") 'flycheck-previous-error)

(setq flycheck-mode-line
      '(:eval
        (pcase flycheck-last-status-change
          (`not-checked nil)
          (`no-checker (propertize " -" 'face 'flycheck-warning))
          (`running (propertize " ✷" 'face 'success))
          (`errored (propertize " !" 'face 'flymake-errline))
          (`finished
           (let* ((error-counts (flycheck-count-errors flycheck-current-errors))
                  (no-errors (cdr (assq 'error error-counts)))
                  (no-warnings (cdr (assq 'warning error-counts)))
                  (face (cond (no-errors 'flymake-errline)
                              (no-warnings 'flycheck-warning)
                              (t 'success))))
             (propertize (format "%s/%s" (or no-errors 0) (or no-warnings 0))
                         'face face)))
          (`interrupted " -")
          (`suspicious '(propertize " ?" 'face 'flycheck-warning)))))

(setq flycheck-flake8rc (concat (expand-file-name "~") "/" ".flake8rc"))
