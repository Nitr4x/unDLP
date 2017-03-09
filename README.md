# unDLP

As you probably already know, industrial spying cost millions of dollars to companies every year through data exfiltration, data stealing, etc. In order to protect themselves against this bane, companies invested into DLP technologies, allowing to protect sensitive information from hackers and malicious employees. A few existing solutions allow bypassing such security measures. However, none of them are flawless, discrete, or efficient enough to guarantee success. That is why unDLP was born.

In a few words, unDLP aim to discreetly exfiltrate information via multiple covert channel. At the moment, only one have been implemented, HTTPS.

## Requirements

A few modules are required to ensure the functionality aspect of unDLP :

* Moose
* JSON::MaybeXS;
* Term::ProgressBar
* Crypt::AES::CTR
* List::SomeUtils

## HTTPS exfiltration method

### Usage

#### Server

```
usage: server.pl [--e PASSWORD] [--help|h]

	 --e: Set the decryption password.
	 --help|h: Display the helper.
```

It is important to note that even if the server is started with a decryption password, it is still possible to handle raw data.

#### Client

```
usage: unDLP.pl -f [FILE, ...] -d DESTINATION -m [HTTPS] [--e PASSWORD] [--size SIZE] [--delay DELAY] [--help|h]

	 -f: File to transfer.
	 -d: Destination.
	 -m: Exfiltration method.
	 --e: Set the encryption password.
	 --size: Set the transfer size.
	 --delay: Set the transfer speed (in second).
	 --help|h: Display the helper.
```

Note: Due to the fact that the transfer uses TLS, it is not mandatory to encrypt your data. Indeed, it terribly affects the transfer speed and could take ages to handle a large file. However, this functionality has been implemented for the next exfiltration methods. Nevertheless, it could be a good way to counter MITM monitoring.

## Todo

* Improve the multi-upload system
* Unitary tests
* DNS exfiltration
* RTCP exfiltration
* [and other type of exfiltration]

## Contribution

Pull requests for new features, bug fixes, and suggestions are welcome !

P.S: keep in mind to respect the Perl::Critic::Freenode policies.
