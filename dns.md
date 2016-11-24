# Domain Name System

## IDN (Internationalizing Domain Name)
https://tools.ietf.org/html/rfc3490
IDNA によると、IDN はアプリケーション上で nameprep 処理後、punycode に変換される必要がある。  
nameprep, punycode のどちらの実装も必須(must)としている。  

IDN 以外の URI に関する国際化については、IRI(Internationalized Resource Identifier) としてまとめられている。  
こちらでは、ホスト名部分でのパーセントエンコードの使用が許容されているよう。(ただし、UTF-8 に限る)  
https://www.w3.org/International/wiki/IRIStatus



