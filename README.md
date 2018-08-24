# Buho

## Comenzar a usar el proyecto
1) Copiar el archivo _.env.example_ a _.env_ y cambiar el SECRET_KEY_BASE por el hash generado localmente por el comando ```rake secret```.
2) Copiar el archivo _config/database.example.yml_ a _config/database.yml_ y reemplazar el usuario y password de la DB de development a las correctas locales.

## Login
Hay un usuario creado, con el email _hola@macherit.com_ con password _123456_.

## Troubleshooting

### Rubocop
Antes de comitear, pueden surgir *problemas con Rubocop*, que corrige estilos del código. Lo primero que se puede correr, antes de corregir dichos errores manualmente es ```rubocop --auto-correct``` para autocorregir los errores más simples.
