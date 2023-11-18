(use-modules
  (gnu)
  (gnu home services)
  (gnu home services shells)
  (gnu home services ssh)
  (gnu home services fontutils)
  (gnu packages xorg)
  (guix git))

(define keyboard-layout "us")

(define color-scheme "temperance-day")
(define temperance-color-scheme-checkout
  (git-checkout
    (url "https://github.com/publik-void/temperance-color-scheme.git")))

(define service-set-common-resources
  (list
    (simple-service 'environment-variables
      home-environment-variables-service-type
      ;; TODO: On e.g. Raspberry Pi OS Bookworm, I still get a warning that
      ;; Guile was not able to set the locale.
      `(("GUIX_LOCPATH" . "$HOME/.guix-home/profile/lib/locale")
        ("SSL_CERT_DIR" . "$HOME/.guix-home/profile/etc/ssl/certs")
        ("SSL_CERT_FILE" .
          "$HOME/.guix-home/profile/etc/ssl/certs/ca-certificates.crt")
        ("GIT_SSL_CAINFO" . "$SSL_CERT_FILE")))
    (simple-service 'config-dotfiles
      home-xdg-configuration-files-service-type `(
      ("cross-platform-copy-paste" ,(git-checkout (url
        "https://github.com/publik-void/cross-platform-copy-paste.git")))))
    (simple-service 'dotfiles-desktop home-files-service-type `(
      ;; NOTE: There is also the system-wide `console-font-service-type`, but
      ;; I'm choosing to keep this user-specific. This should also allow me to
      ;; use the console setup on other operating systems.
      (".console-setup.setupcon" ,(plain-file "console-setup.setupcon"
        (string-append
          "FONTFACE='TerminusBold'\n"
          "FONTSIZE='16x32'\n"
          "VIDEOMODE=''\n")))
      (".keyboard.setupcon" ,(plain-file "keyboard" (string-append
        "XKBMODEL=pc105\n"
        "XKBLAYOUT=" keyboard-layout "\n")))))))

(define service-set-common-resources-desktop
  (list
    (simple-service 'config-dotfiles-desktop
      home-xdg-configuration-files-service-type `(
      ("sx" ,(local-file "../files/sx" #:recursive? #t))))
    (simple-service 'dotfiles-desktop home-files-service-type `(
      (".Xresources" ,(plain-file "Xresources" (string-append
        "#include \".Xresources.d/hack.font.Xresources\"\n"
        "#include \".Xresources.d/temperance/" color-scheme
          ".theme.Xresources\"\n")))
      (".Xresources.d/hack.font.Xresources"
        ,(local-file "../files/Xresources.d/hack.font.Xresources"))
      (".Xresources.d/temperance" ,(file-append
        temperance-color-scheme-checkout
        "/temperance/Xresources/temperance"))))
    (simple-service 'binfiles-desktop home-files-service-type `(
      ("bin/setup-console" ,(program-file "setup-console" #~(begin
        (system*
          #$(file-append
            temperance-color-scheme-checkout
            (string-append "/temperance/console-escape-codes/temperance/"
              color-scheme ".sh"))
          #$(string-append color-scheme ".sh"))
        (system* #$(file-append console-setup "/bin/setupcon") "setupcon"))))))
    (simple-service 'hack-as-preferred-monospace-font
      home-fontconfig-service-type
      (list
        '(alias
          (family "monospace")
          (prefer
           (family "Hack")))))))

(define service-set-ssh
  (list
    (service home-openssh-service-type
      (home-openssh-configuration
        (authorized-keys
          #f
          ;; TODO: Disabled this for now as some `sshd`s apparently require the
          ;; `authorized_keys` file to be owned by the user account under which
          ;; the login is requested, and do not allow for it to be owned by
          ;; `root`, which is the case if it resides in the `/gnu/store`.
          ;;(list
          ;;  (local-file "../files/lasse-mbp-0.pub")
          ;;  (local-file "../files/lasse-mba-0.pub"))
        )))))

(define service-set-git
  (list
    (simple-service 'gitconfig-dotfile home-files-service-type `(
      (".gitconfig" ,(local-file "../files/.gitconfig" "gitconfig"))))))

(define service-set-fish
  (list
    ;; Is this fish service extension still necessary? I previously made the
    ;; mistake of not extending these services via `simple-service` (I just
    ;; used `service`) (TODO)
    (simple-service 'fish-link-config home-fish-service-type
      (home-fish-extension (config (list
        (local-file "../files/link-config.fish")
        (plain-file "setup-console.fish" "\
if begin status is-interactive
    and [ $TERM = linux ]
    and test -x $HOME/bin/setup-console
  end
    $HOME/bin/setup-console
end
")))))
    (simple-service 'fish-config-checkout
      home-xdg-configuration-files-service-type
      `(("config-fish" ,(git-checkout
          (url "https://github.com/publik-void/config-fish.git")))))))

(define service-set-tmux
  (list
    (simple-service 'tmux-config-checkout
      home-xdg-configuration-files-service-type `(
      ("tmux" ,(git-checkout
        (url "https://github.com/publik-void/config-tmux.git")))))))

(define service-set-neovim
  (list
    (simple-service 'neovim-config-checkout
      home-xdg-configuration-files-service-type `(
      ("nvim" ,(git-checkout
        (url "https://github.com/publik-void/config-nvim.git")))))))

(define service-set-xmonad
  (list
    (simple-service 'xmonad-config-checkout
      home-xdg-configuration-files-service-type `(
      ("xmonad" ,(git-checkout
        (url "https://github.com/publik-void/config-xmonad.git")))))))

