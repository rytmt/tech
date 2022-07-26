#!/usr/bin/env python3
#-*- coding: utf-8 -*-

import imaplib

imapHost = "imapserver.local"
userName = "mailaddress@domain.local"
passWord = "mailpassword"
mailBox  = "INBOX"

# imap インスタンス作成
imap = imaplib.IMAP4(imapHost, 143)

# ログイン
imap.login(userName, passWord)

# メールボックスを指定
status, messages = imap.select(mailBox, readonly=True)

# 検索する文字列と文字コードを指定
imap.literal  = u"検索対象の文字列".encode('utf-8')

# ヘッダを指定してメールの uid を検索をする
res, uids = imap.uid('SEARCH', 'CHARSET', 'UTF-8', 'SUBJECT')

# メールの uid をもとにメッセージを取得する
messages = uids[0].decode('utf-8').split()
for uid in messages:
    res, msg = imap.uid('fetch', uid, '(RFC822)') # msg にメールの内容が入ってる

# ログアウト
imap.logout()
