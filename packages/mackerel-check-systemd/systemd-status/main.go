package main

import (
	"context"
	"fmt"
	"log"
	"os/signal"
	"strings"
	"syscall"

	"os"

	"github.com/jessevdk/go-flags"
	"github.com/mackerelio/checkers"
)

var opts struct {
	WarnUnder *float64 `short:"w" long:"warning-under" value-name:"N" description:"Trigger a warning if under the seconds"`
	CritUnder *float64 `short:"c" long:"critical-under" value-name:"N" description:"Trigger a critial if under the seconds"`
	WarnOver  *float64 `short:"W" long:"warning-over" value-name:"N" description:"Trigger a warning if over the seconds"`
	CritOver  *float64 `short:"C" long:"critical-over" value-name:"N" description:"Trigger a critical if over the seconds"`
}

func main() {

	ckr := run(os.Args[1:])
	ckr.Name = "systemd"
	ckr.Exit()
}

func run(args []string) *checkers.Checker {

	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	_, err := flags.ParseArgs(&opts, args) // <- (1) Processing command line parameters
	if err != nil {
		os.Exit(1)
	}

	services, err := getServices(ctx)
	if err != nil {
		log.Fatalln(err)
	}

	msg := strings.Builder{}
	checkSt := checkers.OK

	failedServices := []service{}

	for _, s := range *services {
		if s.failed {
			checkSt = checkers.CRITICAL
			failedServices = append(failedServices, s)
		}
	}

	if checkSt != checkers.OK {

		names := []string{}

		for _, s := range failedServices {
			names = append(names, s.DisplayName())
		}

		servicesReport := strings.Join(names, ", ")
		fmt.Fprintf(&msg, "failed services: %s", servicesReport)

	}

	return checkers.NewChecker(checkSt, msg.String())
}
