### Main components

* Ansible: 2.8


### Linux basics

##### packages & tools

* dialog
* GNU grep, tr, sed, cat, ...


### VMware vSphere VM deployment 

Create an ansible user with the following permissions:

##### Datastore

 * Allocate space
    
##### Network

 * Assign network

##### Resource

 * Assign virtual machine to resource pool
    
##### Virtual machine

 * Change Configuration
    * Acquire disk lease
    * Add existing disk
    * Add new disk
    * Add or remove device
    * Advanced configuration
    * Change CPU count
    * Change Memory
    * Change Settings
    * Change Swapfile placement
    * Change resource
    * Configure Host USB device
    * Configure Raw device
    * Configure managedBy
    * Display connection settings
    * Extend virtual disk
    * Modify device settings
    * Query Fault Tolerance compatibility
    * Query unowned files
    * Reload from path
    * Remove disk
    * Rename
    * Reset guest information
    * Set annotation
    * Toggle disk change tracking
    * Toggle fork parent
    * Upgrade virtual machine compatibility
    * privilege.VirtualMachine.Config.Unlock.label
 * Edit Inventory
    * Create from existing
 * Guest operations
    * Guest operation modifications
 * Interaction
    * Pause or Unpause (not used atm)
    * Power off
    * Power on
 * Provisioning
    * Allow disk access
    * Allow file access
    * Allow read-only disk access
    * Allow virtual machine download
    * Allow virtual machine files upload
    * Clone template
    * Clone virtual machine
    * Create template from virtual machine
    * Customize guest
    * Deploy template
    * Mark as template
    * Mark as virtual machine
    * Modify customization specification
    * Promote disks
    * Read customization specifications

