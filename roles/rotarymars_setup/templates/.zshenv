# Ubuntu's /etc/zsh/zshrc runs a full `compinit` of its own before ~/.zshrc is
# read. That rebuilds ~/.zcompdump on every shell start using an fpath that does
# not yet include the entries .my-zshrc adds, so completions registered there
# (gh, jj, asdf) were silently dropped and the cached dump was never reused.
#
# /etc/zsh/zshrc documents this exact opt-out. Completions are initialised once,
# from .my-zshrc, after fpath is fully assembled.
skip_global_compinit=1
