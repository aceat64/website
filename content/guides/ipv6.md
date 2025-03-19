---
icon: material/ip-network
description: Useful notes for using and planning for IPv6.
hide:
    - toc
---

# IPv6

- Subnets should always be /64s
- Use [SLAAC](<https://en.wikipedia.org/wiki/IPv6#Stateless_address_autoconfiguration_(SLAAC)>) whenever possible, avoid DHCP
- Using nibble-aligned (4 bit) prefixes makes things easier
- `fe80::/10` are [link-local addresses](https://en.wikipedia.org/wiki/Link-local_address)
    - Gross, it's NOT nibble-aligned, which means this range is `fe80::` to `febf::`. So anything that starts with `fe8`, `fe9`, `fea` and `feb`.
- [DHCPv6 prefix delegation](https://en.wikipedia.org/wiki/Prefix_delegation) is a common way ISPs hand out IPv6 ranges.

## How Many /64s

| Prefix                    | /64s       | Subnet Bits |
| ------------------------- | ---------- | ----------- |
| **/48** {: .note-bg }     | **65,536** | **16**      |
| /49                       | 32,768     | 15          |
| /50                       | 16,384     | 14          |
| /51                       | 8,192      | 13          |
| **/52** {: .info-bg }     | **4,096**  | **12**      |
| /53                       | 2,048      | 11          |
| /54                       | 1,024      | 10          |
| /55                       | 512        | 9           |
| **/56** {: .tip-bg }      | **256**    | **8**       |
| /57                       | 128        | 7           |
| /58                       | 64         | 6           |
| /59                       | 32         | 5           |
| **/60** {: .question-bg } | **16**     | **4**       |
| /61                       | 8          | 3           |
| /62                       | 4          | 2           |
| /63                       | 2          | 1           |
| **/64** {: .warning-bg }  | **1**      | **0**       |
