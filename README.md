[![Build status](https://ci.appveyor.com/api/projects/status/edhxb9efv6tyx9p5/branch/master?svg=true)](https://ci.appveyor.com/project/megamorf/citriximagingtools/branch/master)

## ![alt text][attn] *Work in Progress - not yet production-ready*

# CitrixImagingTools
Module to simplify Citrix PVS or MCS based deployments by providing a set of useful helper functions

# Summary
This module aims to help with imaging tasks starting with PVS/MCS version 7.7. The [main reasons](http://blog.itvce.com/2016/01/11/citrix-provisioning-services-pvs-7-6-vs-7-7-vhd-vs-vhdx-and-scale-out-file-server-update/) for this decision are:
* full vhdx support (finally proper block alignment)
* ability to write the vdisk to a filesystem location directly without having to go through PVS which can lead up to a 10x increase in imaging speed
* proper PowerShell support



[attn]: http://i.imgur.com/vN8AUVo.png "Attention: Work in Progress"
