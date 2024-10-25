package main

import (
	"context"
	"log"
	"strings"

	"github.com/coreos/go-systemd/v22/dbus"
)

type service struct {
	name   string
	state  string
	failed bool
}

func (s *service) DisplayName() string {
	return strings.ReplaceAll(s.name, ".service", "")
}

func getServices(ctx context.Context) (*[]service, error) {
	conn, err := dbus.NewSystemdConnectionContext(ctx)
	defer conn.Close()
	if err != nil {
		log.Fatalln(err)
	}

	units, err := conn.ListUnitsContext(ctx)
	if err != nil {
		return nil, err
	}

	return filterServices(units)
}

func filterServices(units []dbus.UnitStatus) (*[]service, error) {

	services := []service{}

	for _, unit := range units {

		if !strings.HasSuffix(unit.Name, "service") {
			continue
		}

		services = append(services, service{
			name:   unit.Name,
			state:  unit.ActiveState,
			failed: unit.ActiveState == "failed",
		})
	}

	return &services, nil
}
