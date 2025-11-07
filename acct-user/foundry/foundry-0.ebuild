# Copyright 2025 Garysrock <master@findingfoundry.com>
# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for the Foundry VTT server"

ACCT_USER_GROUPS=( "foundry" )
ACCT_USER_ID=-1

acct-user_add_deps
