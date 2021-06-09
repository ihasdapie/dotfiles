;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Brian Chen"
      user-mail-address "ihasdapi@gmail.com")




;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; (setq doom-font (font-spec :family "JetBrains Mono" :size 15 :weight 'Regular)
;;       doom-variable-pitch-font (font-spec :family "Nunito" :size 15 :weight 'Light)
;;       doom-big-font (font-spec :family "JetBrains Mono" :size 50))

;; (after! doom-themes
;;   (setq doom-themes-enable-bold t
;;         doom-themes-enable-italic t))
;; (custom-set-faces!
;;   '(font-lock-comment-face :slant italic)
;;   '(font-lock-keyword-face :slant italic))


;; Org Mode Quality-Of-Life Improvements
(setq org-hide-emphasis-markers t) ;; hide /.../ *...*, etc
(add-hook 'org-mode-hook 'variable-pitch-mode) ;; use variable pitch font for org files
(setq org-agenda-files (directory-files-recursively "~/org/" "\\.org$")) ;; use all files in ~org for agenda
(custom-theme-set-faces
        'user
        '(org-block ((t (:inherit fixed-pitch))))
        '(org-code ((t (:inherit (shadow fixed-pitch)))))
        '(org-document-info ((t (:foreground "dark orange"))))
        '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
        '(org-indent ((t (:inherit (org-hide fixed-pitch)))))
        '(org-link ((t (:foreground "royal blue" :underline t))))
        '(org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch)))))
        '(org-property-value ((t (:inherit fixed-pitch))) t)
        '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
        '(org-table ((t (:inherit fixed-pitch :foreground "#83a598"))))
        '(org-tag ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
        '(org-verbatim ((t (:inherit (shadow fixed-pitch))))))



;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")




;; use org autolist on org files
(add-hook 'org-mode-hook (lambda () (org-autolist-mode)))


;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages wath
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how



;; =====================
;; ==> General
;; =====================





;; Set indents to 4 spaces
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq c-set-style "k&r")
(setq c-basic-offset 4)


;; Stop yanking/delete/etc from clobbering the system clipboard
(setq select-enable-clipboard nil)

;; define some bindings for system clipboard
(defun copy-to-clipboard()
  "Copies selection to x-clipboard."
  (interactive)
  (if (display-graphic-p)
      (progn
        (message "Yanked region to x-clipboard.")
        (call-interactively 'clipboard-kill-ring-save)
        )
    (if (region-active-p)
        (progn
          (shell-command-on-region (region-beginning) (region-end) "xsel -i -b")
          (message "Yanked region to clipboard.")
          (deactivate-mark))
      (message "No region active; can't yank to clipboard"))))


(defun paste-from-clipboard ()
  "Pastes from x-clipboard"
  (interactive)
  (if (display-graphic-p)
      (progn
        (clipboard-yank)
        (message "Pasted from system clipboard.")
        )
    (insert (shell-command-to-string "xsel -o - b"))))

(map! :leader
      :desc "copy-to-clipboard"
      "0 y" #'copy-to-clipboard)


(map! :leader
      :desc "paste-from-clipboard"
      "0 p" #'paste-from-clipboard)


;; ;; Make JetBrains Mono Ligatures Work
;; (defconst jetbrains-ligature-mode--ligatures
;;    '("-->" "//" "/**" "/*" "*/" "<!--" ":=" "->>" "<<-" "->" "<-"
;;      "<=>" "==" "!=" "<=" ">=" "=:=" "!==" "&&" "||" "..." ".."
;;      "|||" "///" "&&&" "===" "++" "--" "=>" "|>" "<|" "||>" "<||"
;;      "|||>" "<|||" ">>" "<<" "::=" "|]" "[|" "{|" "|}"
;;      "[<" ">]" ":?>" ":?" "/=" "[||]" "!!" "?:" "?." "::"
;;      "+++" "??" "###" "##" ":::" "####" ".?" "?=" "=!=" "<|>"
;;      "<:" ":<" ":>" ">:" "<>"  ";;" "/==" ".=" ".-" "__"
;;      "=/=" "<-<" "<<<" ">>>" "<=<" "<<=" "<==" "<==>" "==>" "=>>"
;;      ">=>" ">>=" ">>-" ">-" "<~>" "-<" "-<<" "=<<" "---" "<-|"
;;      "<=|" "/\\" "\\/" "|=>" "|~>" "<~~" "<~" "~~" "~~>" "~>"
;;      "<$>" "<$" "$>" "<+>" "<+" "+>" "<*>" "<*" "*>" "</>" "</" "/>"
;;      "<->" "..<" "~=" "~-" "-~" "~@" "^=" "-|" "_|_" "|-" "||-"
;;      "|=" "||=" "#{" "#[" "]#" "#(" "#?" "#_" "#_(" "#:" "#!" "#="
;;      "&="))

;; (sort jetbrains-ligature-mode--ligatures (lambda (x y) (> (length x) (length y))))

;; (dolist (pat jetbrains-ligature-mode--ligatures)
;;   (set-char-table-range composition-function-table
;;                       (aref pat 0)
;;                       (nconc (char-table-range composition-function-table (aref pat 0))
;;                              (list (vector (regexp-quote pat)
;;                                            0
;;                                            'compose-gstring-for-graphic)))))



;; Evil-Mode 
(define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)



;; =====================
;; ==> Package Configs
;; =====================
;;==========> Company
(setq company-idle-delay 0.4)
(setq company-minimum-prefix-length 1)
(setq company-dabbrev-downcase 0)
(setq company-lsp-cache-candidates 'auto)
(defun tab-indent-or-complete ()
  (interactive)
  (if (minibufferp)
      (minibuffer-complete)
    (if (or (not yas-minor-mode)
            (null (do-yas-expand)))
        (if (check-expansion)
            (company-complete-common)
          (indent-for-tab-command)))))


;; performance improvemetns
(global-set-key [backtab] 'tab-indent-or-complete)
(setq savehist-mode nil)
(setq gc-cons-threshold (* 128 1024 1024) )
(setq read-process-output-max 5242880)
(setq lsp-idle-delay 0.500)
(setq history-length 100)
(setq auto-save-default nil)
(put 'minibuffer-history 'history-length 50)
(put 'evil-ex-history 'history-length 50)
(put 'kill-ring 'history-length 25)


(with-eval-after-load 'lsp-mode
  ;; enable log only for debug
  (setq lsp-log-io nil)

  ;; use `evil-matchit' instead
  (setq lsp-enable-folding nil)

  ;; handle yasnippet by myself
  (setq lsp-enable-snippet nil)

  ;; turn off for better performance
  (setq lsp-enable-symbol-highlighting nil)

  ;; use ffip instead
  (setq lsp-enable-links nil)

  ;; auto restart lsp
  (setq lsp-restart 'auto-restart)


  ;; don't ping LSP lanaguage server too frequently
  (defvar lsp-on-touch-time 0)
  (defadvice lsp-on-change (around lsp-on-change-hack activate)
    ;; don't run `lsp-on-change' too frequently
    (when (> (- (float-time (current-time))
                lsp-on-touch-time) 30) ;; 30 seconds
      (setq lsp-on-touch-time (float-time (current-time)))
      ad-do-it)))






;; ============> Tree-Sitter
(use-package! tree-sitter
  :config
  (require 'tree-sitter-langs)
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))


;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)


