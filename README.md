# FibaCloud.com Hostbill Reseller Modules
FibaCloud.com Hostbill Reseller Modules

## Installation
- Download latest module [release](https://github.com/fibacloud/Hostbill/raw/main/FibaCloud-Hostbill-V1.zip);
- Upload archive folder contents to your Hostbill installation root directory;
- Login to Hostbill admin panel;
- Go to System > Modules > Hosting Modules > Inactive > FibaCloud > **Activate**.
- Go to System > Apps Connections > Click **Add new Connection**
- Application: **FibaCloud**
- Name: **Label**
- Username: **Cloud Account Email**
- Password: **Cloud Account Password**
- Click on the **Add new Connection**

## Packade Configuration
 - Go to System > Products & Services > OrderPage > Create A New Product
    - Edit Product
       - go to **Connect with App**
       - App: **FibaCloud**
       - App Connection: **Connection Label**
       - Product ID: **FibaCloud Server Package That Will Match the Package You Edited**
       - Server Location: **Select Server Location**
       - OS Template: **Not Click**
       - Promo Code: **If you have a promotional code, you can pass the code via API.**
       - Click on the **Save Changes**

## OS Configuration
- Go to System > Products & Services > OrderPage > Edit Packade > Components
- Click on the **Add new form field**
- Select field type: **Dropdown**
- Premade fields: **Operating System**
- Edit: **Operating System**
    - Go to Values
       - New Value:
         - CentOS 7
         - CentOS 8 Stream
         - CentOS 9 Stream
         - AlmaLinux 8
         - AlmaLinux 9
         - Debian 10
         - Debian 11
         - Debian 12
         - Debian 13
         - Ubuntu 18.04
         - Ubuntu 20.04
         - Ubuntu 22.04
         - Ubuntu 23.04
         - Ubuntu 23.10
         - Rocky Linux 8
         - Rocky Linux 9
         - Click on the **Save Changes**
      - Click on the **Save Changes**
