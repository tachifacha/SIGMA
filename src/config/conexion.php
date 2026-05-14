<?php
class db
{
    private static $instance = null;
    private $host;
    private $dbname;
    private $dbuser;
    private $dbpass;
    private $conexion;

    private function __construct()
    {
        $this->host = "localhost";
        $this->dbname = "app_datos";
        $this->dbuser = "root";
        $this->dbpass = "";
    }

    private function conectar()
    {
        try {
            $dsn =
                "mysql:host=" .
                $this->host .
                ";dbname=" .
                $this->dbname .
                ";charset=utf8mb4";

            $options = [
                //lanza excepciones para poder manejar errores
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                //usa prepared statements reales del motor
                PDO::ATTR_EMULATE_PREPARES => false,
            ];
            $this->conexion = new PDO(
                $dsn,
                $this->dbuser,
                $this->dbpass,
                $options,
            );
            return $this->conexion;
        } catch (PDOException $e) {
            die("Error al conectar con la BD: " . $e->getMessage());
        }
    }

    //funcion para conectar utilizada en todo el repo
    public static function connect()
    {
        if (self::$instance === null) {
            self::$instance = new self();
            self::$instance->conectar();
        }
        return self::$instance->conexion;
    }

    public function close()
    {
        $this->conexion = null;
        self::$instance = null;
    }
} ?>
<html>
<h1>hola si anda la conexion</h1>

</html>