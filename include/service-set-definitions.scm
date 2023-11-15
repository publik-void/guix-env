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
    (simple-service 'config-dotfiles
      home-xdg-configuration-files-service-type `(
      ("cross-platform-copy-paste" ,(git-checkout (url
        "https://github.com/publik-void/cross-platform-copy-paste.git")))))))

(define service-set-common-resources-desktop
  (list
    (simple-service 'config-dotfiles-desktop
      home-xdg-configuration-files-service-type `(
      ("sx" ,(local-file "../files/sx" #:recursive? #t))))
    (simple-service 'dotfiles-desktop home-files-service-type `(
      ;; NOTE: There is also the system-wide `console-font-service-type`, but
      ;; I'm choosing to keep this user-specific.
      (".console-setup.setupcon" ,(plain-file "console-setup.setupcon" "\
FONTFACE='TerminusBold'
FONTSIZE='16x32'
VIDEOMODE=''
"))
      (".keyboard.setupcon" ,(plain-file "keyboard" (string-append "\
XKBMODEL=pc105
XKBLAYOUT=" keyboard-layout)))
      (".Xresources" ,(plain-file "Xresources" (string-append "\
#include \".Xresources.d/hack.font.Xresources\"
#include \".Xresources.d/temperance/" color-scheme ".theme.Xresources\"
")))
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
        (authorized-keys (list
          (local-file "../files/lasse-mbp-0.pub")
          (local-file "../files/lasse-mba-0.pub")))))))

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

