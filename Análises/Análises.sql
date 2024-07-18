# Total de casos notificados 
SELECT SUM(dengue_cases) AS total_casos FROM projeto_dengue.tb_dengue;

# Análise por Mesorregião
SELECT mesorregiao, total_casos_mesorregiao, ROUND((total_casos_mesorregiao * 100 / 13014346),2) AS porcentagem_mesorregiao
FROM ( 
	SELECT meso_name AS mesorregiao, SUM(dengue_cases) AS total_casos_mesorregiao
	FROM projeto_dengue.tb_dengue
	GROUP BY meso_name
	ORDER BY total_casos_mesorregiao DESC) AS consulta_mesorregiao;

# Análise por região
SELECT regiao, total_casos_regiao, ROUND((total_casos_regiao * 100 / 13014346),2) AS porcentagem_regiao
FROM ( 
	SELECT region_name AS regiao, SUM(dengue_cases) AS total_casos_regiao
	FROM projeto_dengue.tb_dengue
	GROUP BY region_name
	ORDER BY total_casos_regiao DESC) AS consulta_regiao;

# Análise por estado
SELECT 
	estado, 
    total_casos_estado, 
    ROUND((total_casos_estado * 100 / 6732344),2) AS porcentagem_regiao,
    ROUND((total_casos_estado * 100 / 13014346),2) AS porcentagem_total
FROM ( 
	SELECT state_name AS estado, SUM(dengue_cases) AS total_casos_estado
	FROM projeto_dengue.tb_dengue 
	GROUP BY state_name
	ORDER BY total_casos_estado DESC) AS consulta_estado;

# Análise por cidade
SELECT 
	cidade, 
    total_casos_cidade, 
    ROUND((total_casos_cidade * 100 / 6732344),2) AS porcentagem_regiao,
    ROUND((total_casos_cidade * 100 / 13014346),2) AS porcentagem_total
FROM ( 
	SELECT micro_name AS cidade, SUM(dengue_cases) AS total_casos_cidade
	FROM projeto_dengue.tb_dengue 
	GROUP BY micro_name
	ORDER BY total_casos_cidade DESC) AS consulta_cidade;
    
# Porcentagem cidade em relação ao n_casos SP
SELECT cidade, total_casos_cidade, ROUND((total_casos_cidade * 100 / 2549024),2) AS porcentagem_cidade
FROM ( 
	SELECT micro_name AS cidade, SUM(dengue_cases) AS total_casos_cidade
	FROM projeto_dengue.tb_dengue 
	GROUP BY micro_name
	ORDER BY total_casos_cidade DESC) AS consulta_cidade;
    
# Porcentagem cidade em relação ao n_casos RJ
SELECT cidade, total_casos_cidade, ROUND((total_casos_cidade * 100 / 1416295),2) AS porcentagem_cidade
FROM ( 
	SELECT micro_name AS cidade, SUM(dengue_cases) AS total_casos_cidade
	FROM projeto_dengue.tb_dengue 
	GROUP BY micro_name
	ORDER BY total_casos_cidade DESC) AS consulta_cidade;
    
# Análise da cidade com maior incidência em cada região
WITH cidades_por_regiao AS (
  SELECT region_name, micro_name, SUM(dengue_cases) AS total_casos,
    ROW_NUMBER() OVER (PARTITION BY region_name ORDER BY SUM(dengue_cases) DESC) AS ranking
  FROM projeto_dengue.tb_dengue
  GROUP BY region_name, micro_name
)
SELECT 
	region_name as regiao, 
    micro_name AS cidade_com_mais_casos, 
    total_casos, ROUND((total_casos * 100 / 13014346),2) AS porcentagem_total
FROM cidades_por_regiao
WHERE ranking = 1
ORDER BY total_casos DESC;

# Análise por bioma
SELECT bioma, total_casos_bioma, ROUND((total_casos_bioma * 100 / 13014346),2) AS porcentagem_casos_bioma
FROM(
	SELECT biome_name AS bioma, SUM(dengue_cases) AS total_casos_bioma
	FROM projeto_dengue.tb_dengue
	GROUP BY bioma
	ORDER BY total_casos_bioma DESC) AS consulta_bioma;
    
# Análise por porcentagem de urbanização
SELECT
	CASE
		WHEN ROUND(urban) BETWEEN 0 AND 25 THEN '0-25%'
		WHEN ROUND(urban) BETWEEN 26 AND 50 THEN '26-50%'
		WHEN ROUND(urban) BETWEEN 51 AND 75 THEN '51-75%'
		WHEN ROUND(urban) BETWEEN 76 AND 100 THEN '76-100%'
	END AS intervalos_urbanizacao,
	ROUND(AVG(dengue_cases)) AS media_casos_intervalo
FROM projeto_dengue.tb_dengue 
GROUP BY intervalos_urbanizacao
ORDER BY media_casos_intervalo DESC;
    
# Análise por densidade populacional
SELECT
	CASE
		WHEN ROUND(pop_density) BETWEEN 0 AND 1625 THEN '0-1625'
		WHEN ROUND(pop_density) BETWEEN 1626 AND 3250 THEN '1626-3250'
		WHEN ROUND(pop_density) BETWEEN 3251 AND 4875 THEN '3251-4875'
		WHEN ROUND(pop_density) BETWEEN 4876 AND 6500 THEN '4876-6500'
	END AS intervalos_dens_pop,
	ROUND(AVG(dengue_cases)) AS media_casos_intervalo
FROM projeto_dengue.tb_dengue 
GROUP BY intervalos_dens_pop
ORDER BY media_casos_intervalo DESC;

# Análise por tamanho da população
SELECT
	CASE
		WHEN ROUND(population) BETWEEN 16000 AND 3774499 THEN '16000-3774499'
		WHEN ROUND(population) BETWEEN 3774500 AND 7549999 THEN '3774500-7549999'
		WHEN ROUND(population) BETWEEN 7550000 AND 11324499 THEN '7550000-11324499'
		WHEN ROUND(population) BETWEEN 11324500 AND 15050000 THEN '11324500-15050000'
	END AS intervalos_populacao,
	ROUND(AVG(dengue_cases)) AS media_casos_intervalo
FROM projeto_dengue.tb_dengue 
GROUP BY intervalos_populacao
ORDER BY media_casos_intervalo DESC;
    
# Análise por disponibilidade de acesso à água encanada
SELECT
    CASE
        WHEN ROUND(water_network) BETWEEN 0 AND 25 THEN '0-25%'
        WHEN ROUND(water_network) BETWEEN 26 AND 50 THEN '26-50%'
        WHEN ROUND(water_network) BETWEEN 51 AND 75 THEN '51-75%'
        WHEN ROUND(water_network) BETWEEN 76 AND 100 THEN '76-100%'
    END AS intervalo_agua_encanada,
    AVG(dengue_cases) AS media_casos_intervalo
FROM projeto_dengue.tb_dengue
GROUP BY intervalo_agua_encanada
ORDER BY media_casos_intervalo DESC;

# Análise do acesso à água encanada por porcentagem de urbanização
SELECT
	CASE
		WHEN ROUND(urban) BETWEEN 0 AND 25 THEN '0-25%'
		WHEN ROUND(urban) BETWEEN 26 AND 50 THEN '26-50%'
		WHEN ROUND(urban) BETWEEN 51 AND 75 THEN '51-75%'
		WHEN ROUND(urban) BETWEEN 76 AND 100 THEN '76-100%'
	END AS intervalos_urbanizacao,
	ROUND(AVG(water_network)) AS media_acesso_agua
FROM projeto_dengue.tb_dengue 
GROUP BY intervalos_urbanizacao
ORDER BY media_acesso_agua DESC;

# Análise por registros de falta d'água
SELECT
  CASE 
    WHEN water_shortage >= 0 AND water_shortage < 0.25 THEN 'Baixa Escassez de agua'
    WHEN water_shortage >= 0.25 AND water_shortage < 0.5 THEN 'Moderada Escassez de agua'
    WHEN water_shortage >= 0.5 AND water_shortage < 0.75 THEN 'Alta Escassez de agua'
    WHEN water_shortage >= 0.75 AND water_shortage <= 1 THEN 'Muito Alta Escassez de agua'
    ELSE 'N/A'
  END AS categoria_falta_agua,
  AVG(dengue_cases) AS media_casos
FROM projeto_dengue.tb_dengue
GROUP BY categoria_falta_agua
ORDER BY media_casos DESC;

# Análise do número de casos anual e a porcentagem em relação ao total geral
SELECT ano, total_casos_ano, ROUND(total_casos_ano * 100 / SUM(dengue_cases),2) AS porcentagem_ano
FROM projeto_dengue.tb_dengue, (
	SELECT year AS ano, SUM(dengue_cases) AS total_casos_ano
	FROM projeto_dengue.tb_dengue
	GROUP BY ano
	ORDER BY ano) AS casos_ano
GROUP BY ano
ORDER BY ano;

# Análise do número de casos por mês de registro e porcentagem em relação ao total geral
SELECT mes, total_casos_mes, ROUND(total_casos_mes * 100 / SUM(dengue_cases),2) AS porcentagem_mes
FROM projeto_dengue.tb_dengue, (
	SELECT month AS mes, SUM(dengue_cases) AS total_casos_mes
	FROM projeto_dengue.tb_dengue
	GROUP BY mes
	ORDER BY mes) AS casos_mes
GROUP BY mes
ORDER BY mes;

