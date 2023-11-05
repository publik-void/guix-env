(use-modules
  (gnu)
  (guix profiles)
  (guix transformations))

(define guix-base-env
  %base-packages)

(define base-env
  (map specification->package
    (list "fish" "fish-foreign-env" "tmux" "neovim" "git" "openssh-sans-x"
      "mosh" "ncurses")))

(define fish-optional-dependencies-env
  (map specification->package
    (list "parallel" "tar" "botan" "libressl" "xz" "lz4")))

(define tmux-optional-dependencies-env
  (map specification->package
    (list)))

(define neovim-optional-dependencies-env
  (map specification->package
    (list
      "ripgrep" "fd"
      ;; TODO: "efm-langserver"/"go-efm-langserver" not available
      "python" "python-watchdog" "python-pynvim" "python-flake8"
      "shellcheck")))

(define guix-env
  (map specification->package
    (list "guix" "guile")))

(define encryption-env
  (map specification->package
    (list "libressl" "gnupg" "botan")))

(define compression-env
  (map specification->package
    (list "tar" "gzip" "zip" "unzip" "p7zip" "bzip2" "xz" "lz4")))

(define cxx-env
  (map specification->package
    (list "gcc-toolchain" "clang-toolchain" "make" "ninja" "cmake" "boost")))

(define writing-env
  (map specification->package
    (list "tectonic" "pandoc"))) ; "asciidoctor" not available
    ;; TODO: "ruby-asciidoctor" is available, but needs extra config

(define python-env
  (map specification->package
    (list "python" "python-numpy" "python-scipy"))) ; "poetry" currently fails

(define julia-env
  (map specification->package
    (list "julia")))

(define desktop-env
  (map specification->package
    (list
      "xmonad" "xmessage" "ghc" "ghc-xmonad-contrib" "gcc-toolchain"
      "ungoogled-chromium"
      "openssh"
      "st")))

(define transform
  (options->transformation
    ;;'((with-patch . "st=https://st.suckless.org/patches/bold-is-not-bright/st-bold-is-not-bright-20190127-3be4cf1.diff"))))
    '()))
