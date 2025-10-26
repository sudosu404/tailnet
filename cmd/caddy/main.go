// Copyright Hector @sudosu404 & AUTHORS
// SPDX-License-Identifier: AGPL3

package main

import (
	caddycmd "github.com/caddyserver/caddy/v2/cmd"

	_ "github.com/caddyserver/caddy/v2/modules/standard"
	_ "github.com/sudosu404/tailnet-proxy"
)

func main() {
	caddycmd.Main()
}
