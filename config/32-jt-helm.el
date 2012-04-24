(add-to-list 'load-path (concat thirdparty-dir "helm/"))
(require 'helm-config)
(require 'helm-net) ; google
(require 'helm-regexp)

(global-set-key (kbd "C-x C-h") 'helm-mini)
(setq helm-occur-mode-line "") ; keep occur from crashing
(setq-default helm-mode-line-string "") ; keep from crashing if we don't helm-mini first

(defalias 'regexp 'helm-regexp)
(defalias 'mark-ring 'helm-mark-ring)
(defalias 'kill-ring 'helm-kill-ring)
(defalias 'apropos 'helm-c-apropos)
(defalias 'top 'helm-top)
(defalias 'ucs 'helm-ucs)
(defalias 'colors 'helm-colors)
(defalias 'calculator 'helm-calculator)
