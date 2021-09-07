# Volterra Example - Single App, Single Site

This is a teraform example of a single application and a single site.

This is based on the documentation available at [Volterra.io](http://volterra.io)

## Explanation

As part of learning the Volterra platform, I have created a few scenario's that shows different functionality. 
This scenario is the single application, within a single namesapce and single site.

This will become clearer over the course of the README.


## Architecture

The architecture is relatively simple. I have a single application that is an API that has multiple enpoints.
This application is distributed to a number of volterra edge sites. In the Volterra lexicon these are called Regional Edge sites or RE.

Volterra edge sites are sites that are fully managed by Volterra. This makes them a good place to start, and to get up and running quickly.

### Applications

I have a single application that is an API - the starwars API.
It has the following endpoints

/people
/starships
/vehicles
/species
/films

Each endpoint has a number of records (and some refer to each other).

At the / endpoint there is a simple website.


### Load Generator

I have created a load generator application. This application does the following things:

1. Uses the tor network in order to present different source IP addresses
2. Runs a basic shell script to push some traffic through the API endpoints.

### Namespace

There is a single namespace in the example application. This is created by the terraform scripts.

This is configured by the terraform variable **ns**. 

```
variable "ns" { default = "s-vk" }
```

In my example, I'm using my initials as the namespace 

### Sites

Volterra has the concept of sites. Within the example, there is a single site. 
The site is configured using a concatenation of the terraform variable namespace name, and adding the suffix **vs** to denote a virtual site.

```
name      = format("%s-vs", volterra_namespace.ns.name)
```

The net effect is that the namespace name has **vs** added to it, so in this example, it will be **s-vk-vs**.

The resource that I use in terraform to create the virtual site is below:

```
resource "volterra_virtual_site" "main" {
  name      = format("%s-vs", volterra_namespace.ns.name)
  namespace = volterra_namespace.ns.name
  depends_on = [time_sleep.ns_wait]

  labels = {
    "ves.io/siteName" = "ves-io-sg3-sin"
  }
  site_selector {
    expressions = var.site_selector
  }
  site_type = "REGIONAL_EDGE"
}
```

The three important pieces here are:

- labels
- site selector
- site type

**Labels**

This is a label that I can use to identify this particular object. This object is identified using the site name.

**Site Selector**

This is a selector that I can use to choose how I interact with other labels in the volterra world. I'm using the variable **site_selector** which maps to three volterra sites.

```
variable "site_selector" { default = [ "ves.io/siteName in (ves-io-sg3-sin, ves-io-ny8-nyc, ves-io-os1-osa)" ] }
```

This has the effect of choosing the three volterra sites when I deploy anything using this partcular site.


**Site Type**

The site type is the type of site I'm going to install.
The allowed values here are **CUSTOMER_EDGE** or **REGIONAL_EDGE**.
Regional edge means "in a volterra point of presence", and Customer Edge means "in your own point of presence".

I have selected regional edge as it's less work, and means that I can be up and running quickly.

### Virtual Kubernetes

There is also a virtual kubernetes site, vk8s for short. This is associated with the site, this is explained later and is primarily for deployment purposes.

Virtual kubernetes is a kubernetes like API that allows me to run a virtual kubernetes deployment within the Volterra RE (Regional Edge) site. The virtual kubernetes site and API allows me to deploy pods and create services. This allows me to use standard kubernetes devices, such as manifests, and so on to deploy my applications.

```
resource "volterra_virtual_k8s" "vk8s" {
  name      = format("%s-vk8s", volterra_namespace.ns.name)
  namespace = volterra_namespace.ns.name
  depends_on = [volterra_virtual_site.main]

  vsite_refs {
    name      = volterra_virtual_site.main.name
    namespace = volterra_namespace.ns.name
  }
}
```

The **vsite_refs** is the important part here. 
This associates this virtual kubernetes site with a volterra site. This is a reference to another object within the Volterra system. In this case, we are associating the virtual site we created above with our virtual kubernetes instance.



### API Discovery

I have enabled API discovery - as the application I have deployed is an API.

The mechanism to do this is to enable what we call an "application type". 
The application type can be used to contain what we call "features". 
Creating a custom one just makes it easier to handle later on.
I have named it after my application (it makes sense).

Each application type has a number of features. 
I have enabled all of the features, but you can read more about them [here](https://www.volterra.io/docs/how-to/app-security/apiep-discovery-control?query=app%20type)

```
resource "volterra_app_type" "at" {
  // This naming simplifies the 'mesh' cards
  name      = var.manifest_app_name
  namespace = "shared"
  features {
    type = "BUSINESS_LOGIC_MARKUP"
  }
  features {
    type = "USER_BEHAVIOR_ANALYSIS"
  }
  features {
    type = "PER_REQ_ANOMALY_DETECTION"
  }
  features {
    type = "TIMESERIES_ANOMALY_DETECTION"
  }
  business_logic_markup_setting {
    enable = true
  }
}
```

This essentially sets up a custom application type with all of the features enabled. 
This will automatically create a card named after your app type when you deploy your application.

### Load Balancer

### Origin Pool
