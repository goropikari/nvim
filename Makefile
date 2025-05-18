clean:
	rm -rf ~/.local/share/nvim
	rm -rf ~/.local/state/nvim

.PHONY: fmt
fmt:
	stylua -g '*.lua' -- .
	dprint fmt **/*.md **/*.toml

.PHONY: lint
lint:
	typos -w

.PHONY: check
check: lint fmt
