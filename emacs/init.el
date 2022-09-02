;;; customizations file

(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file)

;; Some sane defaults (https://sam217pa.github.io/2016/09/02/how-to-build-your-own-spacemacs/)
(setq delete-old-versions -1)		; delete excess backup versions silently
(setq version-control t)		; use version control
(setq vc-make-backup-files t)		; make backups file even when in version controlled dir
(setq backup-directory-alist `(("." . "~/.emacs.d/backups"))) ; which directory to put backups file
(setq vc-follow-symlinks t)				       ; don't ask for confirmation when opening symlinked file
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t))) ;transform backups file name
(setq inhibit-startup-screen t)	; inhibit useless and old-school startup screen
(setq ring-bell-function 'ignore)	; silent bell when you make a mistake
(setq coding-system-for-read 'utf-8)	; use utf-8 by default
(setq coding-system-for-write 'utf-8)
(setq sentence-end-double-space nil)	; sentence SHOULD end with only a point.
(setq default-fill-column 80)		; toggle wrapping text at the 80th character
(setq initial-scratch-message "Welcome to Emacs") ; print a default message in the empty scratch buffer opened at startup

;; No Menu Bars
(menu-bar-mode -1)
(tool-bar-mode -1)

(require 'package)

;; Use Package

(setq package-enable-at-startup nil) ; tells emacs not to load any packages before starting up
;; the following lines tell emacs where on the internet to look up
;; for new packages.
(setq package-archives '(("org"       . "http://orgmode.org/elpa/")
                         ("gnu"       . "http://elpa.gnu.org/packages/")
                         ("melpa"     . "https://melpa.org/packages/")))
(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package) ; unless it is already installed
  (package-refresh-contents) ; updage packages archive
  (package-install 'use-package)) ; and install the most recent version of use-package

(eval-when-compile
  (require 'use-package))

;; General Packages

(use-package general
  :ensure t
  :config (general-define-key "C-'" 'avy-goto-word-1))

(use-package avy
  :ensure t
  :commands (avy-goto-word-1))

(use-package which-key
  :ensure t
  :config (which-key-mode))

(use-package flx :ensure t)

(use-package ivy
  :ensure t
  :config
  (setq ivy-re-builders-alist
	'((t . ivy--regex-fuzzy))))

(use-package counsel :ensure t)
(use-package swiper :ensure t)   
(use-package hydra :ensure t)   

(use-package evil
  :ensure t
  :config (evil-mode))

;; Projects

(use-package projectile
  :ensure t
  :init (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("s-p" . projectile-command-map)
              ("C-c p" . projectile-command-map)))

(use-package counsel-projectile :ensure t)

;; Treemacs

(use-package treemacs
  :defer t
  :ensure t
  :config
    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always))

(use-package treemacs-evil
  :defer t
  :ensure t
  :after (treemacs evil))

(use-package treemacs-projectile
  :defer t
  :ensure t
  :after (treemacs projectile))

;; Clojure

(use-package clojure-mode
  :defer t
  :ensure t)

(use-package lispy
  :defer t
  :ensure t
  :hook ((clojure-mode . lispy-mode)
	 (emacs-lisp-mode . lispy-mode)))

(use-package lispyville
  :defer t
  :ensure t
  :hook (lispy-mode . lispyville-mode)
  ;; :init (general-add-hook 'lispy-mode-hook #'lispyville-mode)
  :config (lispyville-set-key-theme
	   '(operators
	     C-w
	     slurp/barf-lispy)))

(use-package cider
  :defer t
  :ensure t)

;; LSP

(use-package company
  :defer t
  :ensure t)

(use-package lsp-mode
  :defer t
  :ensure t
  :hook ((clojure-mode . lsp)
         (clojurec-mode . lsp)
         (clojurescript-mode . lsp)))

(use-package lsp-ui
  :defer t
  :ensure t
  :commands lsp-ui-mode)

(use-package lsp-treemacs
  :defer t
  :ensure t
  :config (lsp-treemacs-sync-mode 1))

;; Themes

(use-package solarized-theme
  :ensure t
  :config (load-theme 'solarized-dark))

;; Key Bindings

(setq  x-meta-keysym 'super
       x-super-keysym 'meta)

(general-define-key
  :states '(normal visual insert emacs)
  :prefix "SPC"
  :non-normal-prefix "M-SPC"
  "/"   '(counsel-rg :which-key "ripgrep") ; You'll need counsel package for this
  "TAB" '(cust-switch-to-previous-buffer :which-key "previous buffer")
  "SPC" '(counsel-M-x :which-key "M-x")
  "ff"  '(counsel-find-file :which-key "find files")
  ;; Buffers
  "bb"  '(ivy-switch-buffer :which-key "switch buffer")
  "bd"  '(kill-this-buffer :which-key "kill this buffer")
  ;; Window
  "wl"  '(windmove-right :which-key "move right")
  "wh"  '(windmove-left :which-key "move left")
  "wk"  '(windmove-up :which-key "move up")
  "wj"  '(windmove-down :which-key "move bottom")
  "wv"  '(split-window-right :which-key "split right")
  "w-"  '(split-window-below :which-key "split bottom")
  "wd"  '(delete-window :which-key "delete window")
  ;; Others
  "at"  '(ansi-term :which-key "open terminal")
  "fd"  '(cust-find-user-init-file :which-key "open init.el")
  "fy"  '(camdez/show-buffer-file-name :which-key "copy path of buffer to clipboard")
  "gl"  '(git-link :which-key "open code in github")
  ;; projectile
  "pc"  '(counsel-projectile :which-key "Jump to a project buffer or file, or switch project")
  "pp"  '(counsel-projectile-switch-project :which-key "find project")
  "pf"  '(counsel-projectile-find-file :which-key "fuzzy search find file")
  "ps"  '(counsel-ag :which-key "fuzzy search in project")
  "pb"  '(counsel-projectile-switch-to-buffer :which-key "find buffer")
  "pk"  '(projectile-kill-buffers :which-key "kill buffers")
  "pt"  '(treemacs :which-key "show tree")
  ;; search
  "ss"  '(swiper-isearch :which-key "search")
  ;; clojure
  "ra"  '(cider-test-run-ns-tests :which-key "run all tests ns")
  "rc"  '(cider-connect :which-key "connect to repl")
  "rd"  '(cider-doc :which-key "get doc of clojure var")
  "rg"  '(cider-find-var :which-key "go to definition of clojure var")
  "ri"  '(cider-jack-in :which-key "create cider repl")
  "rl"  '(cider-load-buffer :which-key "load current buffer into repl")
  "rn"  '(cider-repl-set-ns :which-key "set repl to current ns")
  "rs"  '(cider-switch-to-repl-buffer :which-key "switch to repl")
  "rt"  '(cider-test-run-test :which-key "run test at point")
  ;; org mode
  "oy" '(org-download-screenshot :which-key "takes a screenshot and adds it to the org document")
  "oY" '(org-download-yank :which-key "gets an image url and adds it to the org document")
  "onl" '(org-roam-buffer-toggle :which-key "shows the backlinks for the org roam node")
  "onf" '(org-roam-node-find :which-key "finds or creates a new org roam node")
  "oni" '(org-roam-node-insert :which-key "inserts a new org roam node into the document")
  "oc" '(completion-at-point :which-key "autocompletes to org roam nodes"))

(general-define-key
 "C-=" '(text-scale-increase :which-key "Increase buffer font size")
 "C--" '(text-scale-decrease :which-key "Decrease buffer font size"))
