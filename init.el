;;; init.el --- GNU Emacs Setup by Ax33L
;;
;;; Commentary:
;;
;; My personal GNU Emacs configuration.
;;
;;; Code:

;;; Initialization

;; increase GC-limit up to 100M for boot speedup
(setq gc-cons-threshold 100000000)

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
(use-package use-package
  :ensure nil
  :custom
  (setq use-package-always-ensure t))

;; Prevent asking for confirmation to kill processes when exiting.
(custom-set-variables '(confirm-kill-processes nil))

;;; Emacs Config
(use-package emacs
  :config
  (tool-bar-mode -1)                    ;; Let's turn off unwanted window decoration.
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  (global-hl-line-mode t)               ;; Highlighting the active line
  (column-number-mode t)                ;; Show column number
  :custom
  (inhibit-startup-screen t)            ;; Don't display the help screen on startup.
  )

;; Font Size - The value is in 1/10pt, so 100 will give you 10pt, etc.
(set-face-attribute 'default nil :height 105)

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

;; eshell tab-complete
(setq eshell-cmpl-cycle-completions nil)

;; Backup disable
(setq make-backup-files         nil) ; Don't want any backup files
(setq auto-save-list-file-name  nil) ; Don't want any .saves files
(setq auto-save-default         nil) ; Don't want any auto saving

;; Use theme
(use-package leuven-theme
  :config
  (load-theme 'leuven t))

;(use-package modus-themes
;  :config
;  (load-theme 'modus-operandi t t))


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
  :diminish
  :hook (company-mode . company-box-mode))


;; Yasnippet
(use-package yasnippet
  :diminish yas-minor-mode
  :config
  (yas-global-mode 1))

;; Snippets collection
(use-package yasnippet-snippets)

;; Ivy
(use-package ivy
  :diminish
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (setq ivy-count-format "(%d/%d) "))

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
;(use-package python
;  :mode ("\\.py\\'" . python-mode)
;  :config
;  (setq python-shell-interpreter "python3"
;	python-shell-interpreter-args "-i"))

(use-package python-mode
;  :hook (python-mode . lsp)
  :custom
  (python-shell-interpreter "python3"))

(use-package lsp-mode
  :init
  :hook
  (lsp-mode . lsp-enable-which-key-integration)
  :commands lsp)

;; Disable LSP Headerline
(setq lsp-headerline-breadcrumb-enable nil)

(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp))))  ; or lsp-deferred


;(use-package elpy
;  :defer t
;  :init
;  (advice-add 'python-mode :before 'elpy-enable))


;; Virtualenv
(use-package pyvenv
  :config
  (pyvenv-mode 1))

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

;; Json
(use-package json-mode
  :defer t
  :config
  (add-to-list 'auto-mode-alist '("\\.json\\'" . json-mode)))

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

;; Shell
(use-package sh-script
  :ensure nil
  :mode
  ("\\.sh\\'" . shell-script-mode)
  ("\\.bash\\'" . shell-script-mode))

;; Web
(use-package web-mode
  :commands (web-mode)
  :mode
  ("\\.html?\\'" . web-mode)
  ("\\.css\\'" . web-mode))

;; Pip
(use-package pip-requirements
  :hook
  (add-hook 'pip-requirements-mode-hook #'pip-requirements-auto-complete-setup))

(use-package csv-mode)

;;; init.el ends here
