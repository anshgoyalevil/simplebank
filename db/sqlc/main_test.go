package db

import (
	"database/sql"
	"log"
	"os"
	"testing"

	"github.com/anshgoyalevil/simplebank/util"
	_ "github.com/lib/pq"
)

var testQueries *Queries
var testDB *sql.DB

func TestMain(m *testing.M) {

	config, loadConfigErr := util.LoadConfig("../..")
	if loadConfigErr != nil {
		log.Fatal("cannot load config:", loadConfigErr)
	}

	var err error
	testDB, err = sql.Open(config.DBDriver, config.DBSource)
	if err != nil {
		log.Fatal("cannot connect to db:", err)
	}

	testQueries = New(testDB)

	os.Exit(m.Run())
}
