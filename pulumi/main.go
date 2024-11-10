package main

import (
	"github.com/pulumi/pulumi-oci/sdk/v2/go/oci/core"
	"github.com/pulumi/pulumi-oci/sdk/v2/go/oci/identity"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi/config"
)

func main() {
	pulumi.Run(func(ctx *pulumi.Context) error {
		cfg := config.New(ctx, "homestack-pulumi")
		rootCompartmentId := cfg.Require("rootCompartmentId")
		compartment, err := identity.NewCompartment(ctx, "homestack", &identity.CompartmentArgs{
			CompartmentId: pulumi.String(rootCompartmentId),
			Description:   pulumi.String("homestack compartment"),
			Name:          pulumi.String("homestack"),
			EnableDelete:  pulumi.Bool(true),
			DefinedTags:   pulumi.StringMap{},
			FreeformTags:  pulumi.StringMap{},
		})
		if err != nil {
			return err
		}

		// virtual cloud network
		vcn, err := core.NewVcn(ctx, "homestack-vcn", &core.VcnArgs{
			CompartmentId: compartment.CompartmentId,
			CidrBlock:     pulumi.String("10.0.0.0/16"),
			DisplayName:   pulumi.String("homestack-vcn"),
			DnsLabel:      pulumi.String("homenetwork"),
		})
		if err != nil {
			return err
		}

		// internet gateway
		igw, err := core.NewInternetGateway(ctx, "homestack-igw", &core.InternetGatewayArgs{
			CompartmentId: compartment.CompartmentId,
			VcnId:         vcn.ID(),
			Enabled:       pulumi.Bool(true),
			DisplayName:   pulumi.String("homestack-igw"),
		})
		if err != nil {
			return err
		}

		routeTable, err := core.NewRouteTable(ctx, "homestack-route-table", &core.RouteTableArgs{
			CompartmentId: compartment.CompartmentId,
			VcnId:         vcn.ID(),
			DisplayName:   pulumi.String("homestack-route-table"),
			RouteRules: core.RouteTableRouteRuleArray{
				core.RouteTableRouteRuleArgs{
					NetworkEntityId: igw.ID(),
					Destination:     pulumi.String("0.0.0.0/0"),
					DestinationType: pulumi.String("CIDR_BLOCK"),
				},
			},
		})
		if err != nil {
			return err
		}

		securityList, err := core.NewSecurityList(ctx, "homestack-security-list", &core.SecurityListArgs{
			CompartmentId: compartment.CompartmentId,
			VcnId:         vcn.ID(),
			EgressSecurityRules: core.SecurityListEgressSecurityRuleArray{
				core.SecurityListEgressSecurityRuleArgs{
					Destination:     pulumi.String("0.0.0.0/0"),
					Protocol:        pulumi.String("all"),
					DestinationType: pulumi.String("CIDR_BLOCK"),
					Stateless:       pulumi.Bool(false),
				},
			},
			IngressSecurityRules: core.SecurityListIngressSecurityRuleArray{
				core.SecurityListIngressSecurityRuleArgs{
					Protocol:    pulumi.String("6"), // TCP
					Source:      pulumi.String("0.0.0.0/0"),
					Description: pulumi.String("SSH from anywhere"),
					TcpOptions: &core.SecurityListIngressSecurityRuleTcpOptionsArgs{
						Max: pulumi.Int(22),
						Min: pulumi.Int(22),
					},
					SourceType: pulumi.String("CIDR_BLOCK"),
					Stateless:  pulumi.Bool(false),
				},
				core.SecurityListIngressSecurityRuleArgs{
					Protocol:    pulumi.String("1"), // ICMP
					Source:      pulumi.String("0.0.0.0/0"),
					Description: pulumi.String("ICMP from anywhere"),
					IcmpOptions: &core.SecurityListIngressSecurityRuleIcmpOptionsArgs{
						Type: pulumi.Int(3),
						Code: pulumi.Int(4),
					},
					SourceType: pulumi.String("CIDR_BLOCK"),
					Stateless:  pulumi.Bool(false),
				},
			},
		})
		if err != nil {
			return err
		}

		core.NewSubnet(ctx, "homestack-public-subnet", &core.SubnetArgs{
			CidrBlock:               pulumi.String("10.0.0.0/24"),
			CompartmentId:           compartment.CompartmentId,
			VcnId:                   vcn.ID(),
			DisplayName:             pulumi.String("homestack-public-subnet"),
			DnsLabel:                pulumi.String("publicsubnet"),
			ProhibitInternetIngress: pulumi.Bool(false),
			ProhibitPublicIpOnVnic:  pulumi.Bool(false),
			RouteTableId:            routeTable.ID(),
			SecurityListIds:         pulumi.StringArray{securityList.ID()},
		})

		return nil
	})
}
