(add-to-list 'load-path (concat thirdparty-dir "projectile/"))

(require 'projectile)
(projectile-global-mode)

(setq projectile-enable-caching t)

(require 'helm-projectile)
(global-set-key (kbd "C-c h") 'helm-projectile)
