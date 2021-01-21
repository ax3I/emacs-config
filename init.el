;;; init.el --- GNU Emacs Setup by Ax33L
;;
;;; Commentary:
;;
;; My personal GNU Emacs configuration.
;;
;;; Code:

;;; Package Support
(require 'package)

;; Configure package sources
(setq package-enable-at-startup nil)    ;; prevents a second package load and slightly improves startup time
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
;	                         ("org" . "https://orgmode.org/elpa/")
;                                 ("elpa" . "https://elpa.gnu.org/packages/")))
;; fix "Failed to download 'gnu' archive"
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
(package-initialize)

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Always download package if not exist
(setq use-package-always-ensure t)

;; Prevent asking for confirmation to kill processes when exiting.
(custom-set-variables '(confirm-kill-processes nil))

;;; Emacs Config
(use-package emacs
  :config
  (tool-bar-mode -1)                    ;; Let's turn off unwanted window decoration.
  (menu-bar-mode -1)
  (scroll-bar-mode t)
  (global-hl-line-mode t)               ;; Highlighting the active line
  (column-number-mode t)                ;; Show column number
  :custom
  (inhibit-startup-screen t)            ;; Don't display the help screen on startup.
  )

;; Move custom data
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

;; Maximize on startup.
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; Ask y-n instead yes-no
(defalias 'yes-or-no-p 'y-or-n-p)

;; Delete trailing spaces and add new line in the end of a file on save.
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq require-final-newline t)

;; Show full path in the title bar.
(global-visual-line-mode t)
(setq-default frame-title-format "%b (%f)")

;; Backup disable
(setq make-backup-files         nil) ; Don't want any backup files
(setq auto-save-list-file-name  nil) ; Don't want any .saves files
(setq auto-save-default         nil) ; Don't want any auto saving

;; Use theme
(use-package leuven-theme
  :config
  (load-theme 'leuven t))


;;; Packages

;; Diminish minor modes
(use-package diminish)

;; Help for keybindings
(use-package which-key
  :init
  (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

;; Git Magic
(use-package magit)

;; Display line changes in gutter based on git history. Enable it everywhere.
(use-package git-gutter
  :diminish
  :config
  (global-git-gutter-mode +1))

;; Syntax Check
(use-package flycheck
  :diminish
  :config
  (add-hook 'after-init-hook 'global-flycheck-mode)
  (setq-default flycheck-highlighting-mode 'lines)
  )

;; Complete Anything
(use-package company
  :diminish
  :config
  (add-hook 'after-init-hook 'global-company-mode)
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))


;; Yasnippet
(use-package yasnippet
  :diminish yas-minor-mode
  :config
  (yas-global-mode 1))

;; Snippets collection
(use-package yasnippet-snippets
  :ensure t)

;; Ivy
(use-package ivy
  :diminish
  :config
  (ivy-mode 1))

;; Projectile
(use-package projectile
  :diminish projectile-mode
  :config
  (projectile-mode +1))

;; Auto ()
(use-package smartparens
  :diminish
  :config
  (add-hook 'prog-mode-hook 'smartparens-mode))

;; Highlight parens etc. for improved readability.
(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))


;;; Languages

;; Python
(use-package python-mode
  :custom
  (python-shell-interpreter "python3"))

(use-package elpy
  :defer t
  :init
  (advice-add 'python-mode :before 'elpy-enable))

;; Black formatter. Need: pip3 install black
(use-package blacken
  :config
  (add-hook 'python-mode-hook 'blacken-mode))

;; Groovy
(use-package groovy-mode
  :mode (("\\.groovy\\'" . groovy-mode)
         ("Jenkinsfile\\'" . groovy-mode)))

;; Dockerfile
(use-package dockerfile-mode
  :mode
  ("Dockerfile\\'" . dockerfile-mode))

;; Yaml
(use-package yaml-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode)))

;; Markdown
(use-package markdown-mode
  :defer t
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;; Bazel
(use-package bazel-mode
  :defer t)

;; Nginx
(use-package nginx-mode
  :defer t)

;; UML diagramms
(use-package plantuml-mode
  :defer t)

;;; init.el ends here
