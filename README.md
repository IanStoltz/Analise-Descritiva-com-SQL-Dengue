# Análise Descritiva com SQL - Dengue
Incidência da dengue no Brasil entre 2000 e 2019.

# Introdução

---

O SQL, ou Linguagem de Consulta Estruturada, em português, é uma linguagem de programação amplamente utilizada para gerenciar, consultar e manipular bancos de dados relacionais. Neste projeto, o SQL desempenhou um papel fundamental, servindo como a principal ferramenta para criar e conduzir o projeto.

A dengue é uma doença viral transmitida pelo mosquito *Aedes aegypti.* Os sintomas incluem febre alta, dores musculares, dores de cabeça e erupções cutâneas. Em casos mais graves, pode evoluir gerando complicações severas e até a morte.

A análise de dados da dengue é importante para monitorar e controlar a propagação da doença. Esses dados permitem que os profissionais de saúde identifiquem áreas de surto, tomem medidas preventivas e adotem estratégias eficientes de controle do vetor. Além disso, a análise dos dados epidemiológicos auxilia na identificação vulnerabilidades e na implementação de ações direcionadas para prevenir novos casos. A compreensão desses dados é fundamental para o planejamento de políticas de saúde e para a prevenção e combate efetivo da dengue.

---

# Fonte de dados

---

Os dados foram retirados do [Kaggle](https://www.kaggle.com/), do dataset “[Brazil Dengue Dataset 2000-2019](https://www.kaggle.com/datasets/raomuhammadsaeedali/brazil-dengue-dataset-2000-2019?select=data_desc.csv)”.

O número da população, população urbana, porcentagem de população com acesso à água encanada e notificações de caso são provenientes da plataforma [DATASUS](https://datasus.saude.gov.br/), departamento responsável por coletar, analisar e disponibilizar dados de saúde no Brasil.

O dataset fornecido contém informações abrangentes sobre características geográficas e ambientais em microrregiões do Brasil de 2000 a 2019. O conjunto de dados inclui códigos e nomes de microrregiões, mesorregiões, estados, regiões, biomas e ecozonas. Também contém informações sobre regimes climáticos, meses, anos, horários, casos de dengue, estimativas de população, densidade populacional, temperaturas máximas e mínimas, índice de severidade da seca de Palmer, percentuais de população urbana, acesso à rede de água e frequência de escassez de água relatada. Essas informações são específicas para cada microrregião e fornecem dados sobre a dinâmica da população, padrões climáticos, urbanização, recursos hídricos e incidência de doenças.

Os dados estão disponíveis no formato CSV e foram carregados no MySQL por linha de comando com o seguinte código:

```sql
mysql --local-infile=1 -u root -p

SET GLOBAL local_infile = true;

LOAD DATA LOCAL INFILE 'Documents/Codes/SQL/Projeto Dengue/tb_dengue.csv' 
INTO TABLE `projeto_dengue`.`tb_dengue` CHARACTER SET UTF8
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
```

O conjunto de dados é composto de 26 colunas e 133680 linhas. No entanto, foram descritas aqui somente as colunas utilizadas durante a análise.

1. micro_name - Nome de cada microrregião.
2. meso_name - Nome de cada mesorregião.
3. state_name - Nome de cada estado.
4. region_name - Nome da região.
5. biome_name - Nome do bioma da região.
6. month - Mês do registro.
7. year - Ano do registro.
8. dengue_cases - Número de casos notificados registrados no sistema de notificações de doenças do Brasil ([SINAN](https://portalsinan.saude.gov.br/)).
9. population - População estimada baseada nos censos de 2000 e 2010.
10. pop_density - Densidade populacional por km².
11. urban - Porcentagem de habitantes vivendo em áreas urbanas de acordo com o [censo 2010](https://censo2010.ibge.gov.br/).
12. water_network - Porcentagem de habitantes com acesso à água encanada, de acordo com o [censo 2010](https://censo2010.ibge.gov.br/).
13. water_shortage - Frequência de registros de falta d’água por microrregião de 2000 a 2016. 

---

# Definição dos objetivos

---

Foram definidos os seguintes objetivos para análise.

1. **Análises Geográficas**
    1. Análise da mesorregião, região, estado e cidades mais afetadas.
    2. Análise das cidades mais afetadas em cada região.
    3. Análise do Bioma com maior número de casos.
2. **Análises populacionais**
    1. Análise da urbanização e ocorrência de casos.
    2. Análise da população e ocorrência de casos.
    3. Análise da densidade populacional e ocorrência de casos.
3. **Análise por recursos hídricos**
    1. Análise da disponibilidade de acesso à água e número de casos.
    2. Análise da escassez de água e número de casos.
4. **Análises temporais**
    1. Análise do número de registros por ano.
    2. Análise do número de registros por mês.

---

# Análise

---

## Tratamento de valores ausentes, duplicados e outliers

---

Todas as colunas foram consultadas buscando valores ausentes.

As colunas que apresentaram valores ausentes foram dengue_cases, population, pop_density, pdsi (não utilizada) e water_shortage. 

Os valores nulos referentes a dengue_cases, population e pop_density representaram 5% dos dados, totalizando 6684 registros. Estes foram substituídos pela mediana da categoria respectiva, realizando imputação a fim de preencher os dados e enriquecer a análise. 

Os valores ausentes referentes à variável water_shortage representaram 2,69% dos dados, totalizando 3600 registros. Estes também foram substituídos pela mediana a fim de preencher os dados.

Os valores nulos referentes ao pdsi, totalizaram apenas 12 registros, estes foram removidos a fim de facilitar a análise.

Após o tratamento de valores ausentes os dados totalizaram 133668 registros.

Não foram encontrados dados duplicados no dataset.

Os possíveis outliers presentes nos dados não foram tratados, pois esses valores extremos podem refletir condições específicas, surtos ou variações populacionais relevantes para a análise. A decisão de preservar esses outliers foi tomada para manter a integridade dos dados e permitir insights sobre eventos que possam impactar nos casos da doença.

---

## Análises Geográficas

---

### Total de casos registrados

---

Primeiramente, foi calculado o total de casos registrados durante o período do dataset, 2000 a 2019. Foi utilizada a coluna dengue_cases. Totalizando 13.014.346 ocorrências de dengue. 

![Cálculo do total de casos registrados no período de 2000 a 2019. Fonte: Autor.](https://github.com/IanStoltz/Analise-Descritiva-com-sql-Dengue/blob/main/Imagens/1%20-%20Total%20de%20casos.png)

Cálculo do total de casos registrados no período de 2000 a 2019. Fonte: Autor.

---

### Análise por mesorregião

---

Para identificar a distribuição, porcentagem dos casos e qual a mesorregião apresentou maior risco foi feita a seguinte consulta utilizando as colunas meso_name e dengue_cases. Foram apresentadas somente as 5 regiões mais afetadas.

![Análise do total de casos por mesorregião. Fonte: Autor](https://github.com/IanStoltz/Analise-Descritiva-com-sql-Dengue/blob/main/Imagens/2%20-%20Mesorregi%C3%A3o.png)

Análise do total de casos por mesorregião. Fonte: Autor

**A mesorregião que apresentou maior número de casos foi a Metropolitana De Belo Horizonte com um total de 1.088.760 casos, representando 8.37% do total geral.**

---

### Análise por região

---

Para identificar qual região apresentou maior risco foi a query anterior foi alterada utilizando as colunas region_name e dengue_cases.

![Análise do total de casos por região. Fonte: Autor](https://github.com/IanStoltz/Analise-Descritiva-com-sql-Dengue/blob/main/Imagens/3%20-%20Regi%C3%A3o.png)

Análise do total de casos por região. Fonte: Autor

**Os resultados demonstram que a região Sudeste foi a que apresentou maior número de casos, totalizando 51,73% das notificações (6.732.344 casos), seguida da região Nordeste, Centro Oeste, Norte e Sul.** 

---

### Análise por estado

---

Para identificar os estados mais afetados, a query anterior foi alterada utilizando a coluna state_name. Foram apresentados somente os 10 estados mais afetados .

![Análise do total de casos por estado. Fonte: Autor](https://github.com/IanStoltz/Analise-Descritiva-com-sql-Dengue/blob/main/Imagens/4%20-%20Estado.png)

Análise do total de casos por estado. Fonte: Autor

**O estado com maior número de casos registrados foi São Paulo, representando um total de 2.549.024 ocorrências, 37,86% dos casos da região Sudeste e 19.59% dos casos totais.**

---

### Análise por cidade

---

Para a análise por cidades, a query anterior foi alterada utilizando a coluna micro_name. Foram apresentadas somente as 5 cidades mais afetadas.

![Análise do total de casos por cidade. Fonte: Autor](https://github.com/IanStoltz/Analise-Descritiva-com-sql-Dengue/blob/main/Imagens/5%20-%20Cidade.png)

Análise do total de casos por cidade. Fonte: Autor

**A cidade com maior ocorrência foi a do Rio de Janeiro, com um total de 1.020.174 ocorrências, 15,15% dos casos da região Sudeste, 7.84% dos casos totais, seguida de Belo Horizonte, Goiânia, Fortaleza e Campinas.** 

Se comparada com o número de casos do estado do RJ, a capital do Rio representa 72.03% do número das ocorrências (1.020.174 ocorrências). Se comparada com o número de casos do estado de SP, a capital São Paulo representa apenas 7.36% das ocorrências (187.659 ocorrências). As queries destas duas consultas foram omitidas por não serem um objetivo direto da análise, porém, as consultas estão disponíveis no meu GitHub.

---

### Análise da cidade de maior incidência em cada região

---

![Análise das cidades com maior número de casos em cada região. Fonte: Autor](https://github.com/IanStoltz/Analise-Descritiva-com-sql-Dengue/blob/main/Imagens/6%20-%20Cidade%20por%20regi%C3%A3o.png)

Análise das cidades com maior número de casos em cada região. Fonte: Autor

**As cidades com maior número de casos por região foram Rio de Janeiro, Goiânia, Fortaleza, Manaus e Foz do Iguaçu. Sendo 3 delas cidades com os maiores números de casos total, como visto na análise anterior.**

A query acima utilizou uma função window para particionar os dados por região.

---

### Análise por bioma

---

Como visto nos resultados anteriores, a região que apresentou maior número de casos foi a região Sudeste, composta pelos estados do Rio de Janeiro, São Paulo, Espírito Santo e Minas Gerais. O bioma predominante nesta região é a Mata Atlântica. 

Foi realizada a análise para confirmar se a predominância de casos foi neste bioma. As colunas utilizadas foram biome_name e dengue_cases, com a seguinte query.

![Análise do total de casos por bioma. Fonte: Autor](https://github.com/IanStoltz/Analise-Descritiva-com-sql-Dengue/blob/main/Imagens/7%20-%20Bioma.png)

Análise do total de casos por bioma. Fonte: Autor

**A análise confirma o bioma que mais registrou casos foi a Mata Atlântica, com 6.954.422 casos, apresentando 53.44% do total de casos geral.**

---

## Análise populacional

---

### Análise por urbanização

---

Para verificar se áreas urbanas apresentam maior ou menor número de casos, a porcentagem de urbanização (coluna urban) foi dividida em 4 intervalos de porcentagem, 0-25, 26-50, 51-75, 76-100 e a média de casos para cada intervalo foi calculada.

![Análise da média de casos por intervalos de porcentagem de urbanização. Fonte: Autor](https://github.com/IanStoltz/Analise-Descritiva-com-sql-Dengue/blob/main/Imagens/8%20-%20Urbaniza%C3%A7%C3%A3o.png)

Análise da média de casos por intervalos de porcentagem de urbanização. Fonte: Autor

**Os resultados demonstram que áreas mais urbanizadas apresentam média de casos superior.**

Isso sugere que uma população maior, e consequentemente uma maior densidade populacional podem facilitar a propagação da dengue, ao haver mais hospedeiros para o vírus, assim como áreas mais urbanizadas apresentam maior acesso à assistência médica, colaborando para uma maior notificação de ocorrências.

---

### Análise por densidade populacional

---

Para análise da densidade populacional (coluna pop_density), o n° de habitantes por km² foi dividido em 4 intervalos, 0-1625, 1626-3250, 3251-4875, 4876-6500.

![Análise da média de casos por intervalos de densidade populacional. Fonte: Autor](https://github.com/IanStoltz/Analise-Descritiva-com-sql-Dengue/blob/main/Imagens/9%20-%20Densidade%20Populacional.png)

Análise da média de casos por intervalos de densidade populacional. Fonte: Autor

**Os resultados demonstram que o maior intervalo de densidade populacional não apresenta a maior média de casos, isso sugere que outros fatores estão relacionados ao maior registro de casos.** Não foram encontrados casos no intervalo de 3251-4875 h/km².

---

### Análise por população total

---

Foi avaliada a população (coluna population), que também foi dividida em 4 intervalos, começando por 16.000, menor número registrado e finalizando em pouco mais de 15041894, maior número registrado. O número foi arredondado para os intervalos representarem valores iguais.

![Análise da média de casos por intervalo do tamanho da população. Fonte: Autor](https://github.com/IanStoltz/Analise-Descritiva-com-sql-Dengue/blob/main/Imagens/10%20-%20Popula%C3%A7%C3%A3o%20total.png)

Análise da média de casos por intervalo do tamanho da população. Fonte: Autor

**Os resultados mostram que o maior intervalo populacional também não apresenta a maior média de casos, vindo de encontro com a análise de densidade e sugerindo que outros fatores estão relacionados a um maior registro de casos.**

---

## Análise por recursos hídricos

---

### Análise por disponibilidade de acesso à água encanada

---

A disponibilidade de água encanada e a falta d’água também são fatores que podem influenciar no número de casos. 

Foi visto como resultado nas consultas acima que áreas mais urbanizadas apresentaram maior número de casos. Na consulta abaixo, foi verificado se áreas com maior acesso à água tiveram maior número de casos. A porcentagem de habitantes com acesso (coluna water_network) foi dividida em 4 intervalos.

![Análise da média de casos por intervalo de porcentagem da população com acesso a água encanada. Fonte: Autor](https://github.com/IanStoltz/Analise-Descritiva-com-sql-Dengue/blob/main/Imagens/11%20-%20Recursos%20H%C3%ADdricos.png)

Análise da média de casos por intervalo de porcentagem da população com acesso a água encanada. Fonte: Autor

**Os resultados mostram que áreas com maior acesso à água encanada também apresentam maior número de ocorrências de dengue.** Este resultado provavelmente se dá pelo fato de que áreas mais urbanizadas apresentam maior taxa de população com acesso a este recurso. A query abaixo demonstra isso.

![Análise da média de população com acesso a água encanada por intervalo de porcentagem de urbanização. Fonte: Autor](https://github.com/IanStoltz/Analise-Descritiva-com-sql-Dengue/blob/main/Imagens/12%20-%20Recursos%20H%C3%ADdricos%20II.png)

Análise da média de população com acesso a água encanada por intervalo de porcentagem de urbanização. Fonte: Autor

---

### Análise por registros de falta d’água

---

A escassez de água também pode ser um fator que influencia o número de casos de dengue. A coluna water_shortage foi dividida em 4 categorias, de baixa até alta escassez d’água sendo avaliado o total de casos para cada uma com a seguinte query.

![Análise da média de casos registrados em relação à categorias de falta d’água. Fonte: Autor](https://github.com/IanStoltz/Analise-Descritiva-com-sql-Dengue/blob/main/Imagens/13%20-%20Recursos%20H%C3%ADdricos%20III.png)

Análise da média de casos registrados em relação à categorias de falta d’água. Fonte: Autor

**Os resultados mostram que regiões na categoria de alta e muito alta escassez d’água apresentaram o maior número de casos. Com uma média de 172 e 111 casos, respectivamente.**

Isso pode estar relacionado com uma maior necessidade de armazenamento de água pela população, muitas vezes inadequadamente, como captando água da chuva, armazenada ao ar livre, e por períodos mais longos de tempo, gerando ambientes propícios para o desenvolvimento do mosquito. 

---

## Análises temporais

---

### Análise da incidência de casos anuais

---

Com dados anuais e mensais, as autoridades de saúde podem ajustar suas abordagens com base nos dados observados em anos anteriores. O aumento ou diminuição nos casos anuais pode indicar surtos, sazonalidade ou mudanças nas condições ambientais e sociais.

Foi utilizada a seguinte consulta para verificar o total de casos anuais (coluna year)

![Análise dos registros de caso anualmente e a sua porcentagem relativa ao total de registros. Fonte: Autor](https://github.com/IanStoltz/Analise-Descritiva-com-sql-Dengue/blob/main/Imagens/14%20-%20Casos%20Anuais.png)

Análise dos registros de caso anualmente e a sua porcentagem relativa ao total de registros. Fonte: Autor

**Os resultados mostram que o ano de 2015 foi o ano que apresentou o maior número de casos, com um total de 1.700.074 ocorrências, representando 13.06% do total de casos em todo o período analisado.**

---

### Análise da incidência por mês de registro

---

O total de número de casos por mês (coluna month) também foi analisado, utilizando a seguinte query.

![Análise do total de casos por mês de registro e sua porcentagem relativa ao total de casos. Fonte: Autor](https://github.com/IanStoltz/Analise-Descritiva-com-sql-Dengue/blob/main/Imagens/15%20-%20M%C3%AAs%20de%20registro.png)

Análise do total de casos por mês de registro e sua porcentagem relativa ao total de casos. Fonte: Autor

**O mês que apresentou maior número de casos registrados foi março, com 2.844.516 casos, representando 21.86% do total geral de notificações, seguido de abril, com 2.801.941 casos, representando 21.53% do total.**

Os resultados podem estar relacionados com o período de chuvas. Março e abril são meses que frequentemente marcam o início ou o auge da estação chuvosa em muitas regiões. O aumento das chuvas cria ambientes propícios para a formação de criadouros do mosquito.

---

# Resultados

---

Os resultados das análises dos dados sobre dengue no Brasil revelam diversos insights importantes:

**O total de casos registrados foi de 13.014.346.**

Abaixo serão descritos os resultados de acordo com o contexto analisado.

---

## Geográficos

---

- **Mesorregião Metropolitana de Belo Horizonte**: Mesorregião com o maior número de casos, representando uma significativa parcela do total nacional. 1.088.760 casos, (8,37% do total)
- **Região Sudeste**: Dominante em termos de incidência, com mais da metade dos casos totais. Sugerindo uma concentração de fatores que contribuem para a proliferação do vetor. 6.732.344 casos, 51,73% do total.
- **Estado de São Paulo**: Estado com maior número de casos, indicando possíveis desafios específicos relacionados à saúde pública e ao controle da doença. 2.549.024 casos (37,86% da região Sudeste e 19,59% do total)
- **Cidade do Rio de Janeiro**: A cidade com o maior número de casos, destacando-se como um ponto crítico para intervenções de saúde pública. 1.020.174 casos (15,15% da região Sudeste e 7,84% do total)
- **Bioma Mata Atlântica**: Bioma com maior incidência de casos, possivelmente devido a condições ambientais favoráveis à reprodução do mosquito. 6.954.422 casos (53,44% do total)
- **Cidades mais afetadas em cada região**: As cidades do Rio de Janeiro, Goiânia, Fortaleza, Manaus e Foz do Iguaçu se mostram hotspots de dengue que podem necessitar de atenção especial e recursos direcionados.

---

## Populacionais

---

- **Urbanização**: Áreas mais urbanizadas apresentam maior média de casos, sugerindo que a urbanização está correlacionada com a incidência de dengue. Isso pode estar relacionado à densidade populacional e à infraestrutura urbana que favorece a reprodução do mosquito.
- **População e Densidade Populacional**: Os maiores intervalos de população e densidade populacional não apresentam a maior média de casos, indicando que outros fatores, além da densidade populacional influenciam na propagação da dengue.

---

## **Recursos**

---

- **Acesso à Água**: Áreas com maior acesso à água encanada apresentam maior número de casos. Isso pode estar relacionado à infraestrutura que pode criar ambientes propícios para a reprodução do mosquito.
- **Escassez de Água**: Regiões com alta escassez de água têm um número elevado de casos, o que pode refletir práticas de armazenamento de água que favorecem a criação de focos de mosquitos.

---

## **Temporais**

---

- **Ano de 2015**: Um pico nos casos de dengue, possivelmente relacionado a fatores climáticos, sociais ou a surtos específicos naquele ano.
- **Meses de Março e Abril**: Picos mensais de casos, possivelmente ligado ao clima mais quente e por serem meses que frequentemente marcam o início ou o auge da estação chuvosa em muitas regiões.

---

# Conclusões

---

Esses resultados oferecem um panorama detalhado que pode orientar políticas públicas e estratégias de controle da dengue, ajudando a reduzir a incidência da doença e a mitigando seus impactos.

Algumas recomendações pontuais:

- **Intervenções Geográficas Específicas:**
    - Implementar programas de controle da dengue direcionados especificamente para as cidades e regiões mais afetadas.
- **Educação e Infraestrutura:**
    - Melhorar a educação sobre dispersão da doença, cuidados com saneamento, práticas de armazenamento de água (em locais com maior escassez do recurso).
    - Investir em campanhas de conscientização, infraestrutura, monitoramento e vigilância sanitária para reduzir e mitigar criadouros de mosquitos.
- **Participação Comunitária:**
    - Incentivar a participação ativa das comunidades em programas de controle de mosquitos, como mutirões de limpeza e vigilância comunitária.
- **Preparação Sazonal:**
    - Implementar ou intensificar medidas preventivas antes dos meses de pico (março e abril) para reduzir a incidência de casos.
- **Fortalecimento da Vigilância Epidemiológica:**
    - Fortalecer os sistemas de vigilância para monitorar os casos de dengue em tempo real e permitir respostas mais efetivas durante os surtos.
    - Investir em pesquisas para entender melhor os fatores que influenciam a propagação da dengue, incluindo estudos sobre a resistência dos mosquitos a inseticidas e a eficácia das vacinas.
- **Coordenação Intersetorial:**
    - Coordenar ações entre diferentes setores do governo, como saúde, meio ambiente, saneamento e educação, para implementar um plano abrangente de controle da dengue.
    - Estabelecer parcerias com organizações não governamentais, instituições acadêmicas e o setor privado para desenvolver e implementar programas de prevenção e controle.

Essas recomendações, quando implementadas de maneira integrada e coordenada, podem contribuir para a redução da incidência de dengue no Brasil, melhorando a saúde pública e a qualidade de vida da população.

---

**Se chegou até aqui, agradeço pela leitura do projeto.**

Este foi um projeto de introdução ao MySQL e SQL realizado em 2023

Fique a vontade para fazer críticas, perguntas e sugestões. 

**Meus links:**

**LinkedIn:** https://www.linkedin.com/in/ianrstoltz098/

**E-mail:** mailto:ian.rstoltz@gmail.com

**Portfólio: [Clique aqui](https://www.notion.so/Portf-lio-Ian-Rodrigo-Stoltz-9678c741c8914c3e8ad331278eb2cd80?pvs=21)!**

---
