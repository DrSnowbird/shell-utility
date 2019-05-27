# Steps to mount 2nd drive for booting
Two ways to do it
1.) (Easiest - no mistake happen!) Using Ubuntu GUI 'disk'
2.) Manually create entry in /etc/fstab

## Manually setup /etc/fstab
1. Find UUID
```
sudo blkid
```
2. Create Mount point
``` 
sudo mkdir /mnt/data-4tb
```
3. Edit /etc/fstab
```
UUID=414e60f5-5011-4043-ad35-101d751c12af /mnt/data-4tb ext4 defaults,x-gvfs-show,x-gvfs-name=data-4tb,x-gvfs-icon=data-4tb,x-gvfs-symbolic-icon=data-4tb 0 2
```



