---
layout: "no"
permalink: /multi-code-widget/
---

<style type="text/css">
    body {
        width: 50%;
        margin: auto;
    }
    
    .multicode {
        display: flex;
        flex-wrap: wrap;
        justify-content: flex-start;
    
        width: 100%;
        padding: 0px;
        border: 0px;
        margin: 0px;
    }
    
    .multicode-selector {
        display: none;
    }
    
    .multicode-selector + label {
        order: -1;
    
        padding: 0.5em;
        border-top: 1px;
        border-bottom: 0px;
        border-left: 1px;
        border-right: 1px;
        border-top-left-radius: 5px;
        border-top-right-radius: 5px;
    
        background-color: #c0c0c0;
        border-color: #808080;
        border-style: solid;
    }
    
    .multicode-selector:checked + label {
        background-color: #e0e0e0;
    }
    
    .multicode-selector + label + code {
        display: none;
    }
    
    .multicode-selector:checked + label + code {
        display: block;
    
        width: 100%;
        border: 1px;
        padding: 1em;
        margin: 0px;
        break-before: always;
        page-break-before: always;
    
        background-color: #e0e0e0;
        border-color: #808080;
        border-style: solid;
        white-space: pre;
    }
</style>

blah blah

<div class="multicode">
    <input name="mc00" id="mcs0000" type="radio" class="multicode-selector" checked="checked"/>
    <label for="mcs0000">OpenSSH 7.0</label>
    <code>Host *
    Ciphers base64,rot13
    MACs md5,crc32</code>

    <input name="mc00" id="mcs0001" type="radio" class="multicode-selector"/>
    <label for="mcs0001">OpenSSH 6.5</label>
    <code>Host *
    Ciphers rot13
    MACs md5</code>

    <input name="mc00" id="mcs0002" type="radio" class="multicode-selector"/>
    <label for="mcs0002">Dropbear</label>
    <code>Host *
    Ciphers base64
    MACs crc32</code>
</div>

foo bar baz fuz

