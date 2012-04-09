;; Initialize smex (M-x ido style completion)
(setq smex-save-file smex-file)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
