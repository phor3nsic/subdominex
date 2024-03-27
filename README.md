<h1 align="center">
  SubdomineX
  <br>
</h1>

<h4 align="center">Domain Asset Identification Tool</h4>

<h6 align="center"> Coded with 💙 by ph0r3nsic </h6>
<h6 align="center"> With help of <a href="https://github.com/xen00rw">xen00rw</a></h6>

<p align="center">

<br>
  <!--Tweet button-->
  <a href="https://twitter.com/intent/tweet?text=subdominex%20-%20Domain%20Asset%20Identification%20Tool%20https%3A%2F%2Fgithub.com%2Fphor3nsic%2Fsubdominex%20%23bash%20%23github%20%23linux%20%23infosec%20%23bugbounty" target="_blank">Share on Twitter!
  </a>
</p>

<p align="center">
  <a href="#install-">Install</a> •
  <a href="#examples-">Examples</a> •
  <a href="#contributing-">Contributing</a> •
  <a href="#license-">License</a>
</p>

Install 📡
----------

### Required Tools:

- [subfinder](https://github.com/projectdiscovery/subfinder)
- [assetfinder](https://github.com/tomnomnom/assetfinder)
- [amass](https://github.com/owasp-amass/amass)
- [chaos](https://github.com/projectdiscovery/chaos-client)
- [sublist3r](https://github.com/aboul3la/Sublist3r)
- [findomain](https://github.com/Findomain/Findomain)
- [subscraper](https://github.com/m8sec/subscraper)
- [shuffledns](https://github.com/projectdiscovery/shuffledns)
- [httpx](https://github.com/projectdiscovery/httpx)
- [gospider](https://github.com/jaeles-project/gospider)
- [csprecon](https://github.com/edoardottt/csprecon)

### Clone:

```console
git clone https://github.com/phor3nsic/subdominex
```

Examples 💡
----------

### Single target:
```console
./subdominex.sh example.com
```

### For multi targets:
```console
for x in $(cat targets.txt);do ./subdominex.sh $x;done
```

Contributing 🛠
-------

Just open an [issue](https://github.com/phor3nsic/subdominex/issues) / [pull request](https://github.com/phor3nsic/subdominex/pulls).

License 📝
-------

This repository is under [MIT License](https://github.com/phor3nsic/subdominex/blob/main/LICENSE).  
[ph0r3nsic@wearehackerone.com](mailto:ph0r3nsic@wearehackerone.com) to contact me.