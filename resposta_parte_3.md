# ✍️ Parte 3 – Estratégia de Validação com o Cliente
### Respostas

1. Quais seriam os **principais pontos que você validaria com o cliente?**
    - R: Ao manipular dados originados do ERP do cliente, considero importante a comparação com relatórios conhecidos pelo cliente. Caso exista no ERP, uma forma de mostrar a mesma informação que estou apresentando, procuro colocar os resultados da minha consulta lado a lado com a informação do sistema. Também é importante validar se os números analisados estão de acordo com a realidade do negócio. Por último, verificar se as nomenclaturas das colunas estão de acordo com o entendimento do cliente, para evitar ambiguidade.
    
2. Quais técnicas utilizaria para garantir a **exatidão e a precisão** dos dados?
    - R: Previamente, é possível fazer uma visualização com planilhas de Excel sobre as transformações e cálculos que são realizados na tabela. É uma forma de mostrar o início de cada dado, até a informação desejada, de maneira mais visual. Costumo fazer documentações de memórias de cálculo para relatórios dessa forma, usando um quadro do Notion. É possível descrever o início do cálculo mostrando a estrutura de dados e somente as colunas relevantes ao cliente, como abaixo:

    - | produto_id  | qtde_vendida  | data_emissao  | venda_id |
      | ----------- | ------------- | ------------- | -------- |
      | P0001       | 15            | 2025-02-05    | 1        |
      | P0002       | 8             | 2025-02-10    | 2        |
      | P0002       | 22            | 2025-02-15    | 3        |

3. Quais **consultas você deixaria prontas** para usar na reunião de validação?
    - R: Similar a resposta da segunda pergunta, deixaria prontas consultas que pudessem ajudar o cliente a visualizar os dados antes de serem manipulados, quais cálculos estão sendo feitos, e qual o resultado final, utilizando de preferência, uma amostragem apenas com um produto, ou um fornecedor. O cliente pode ficar ciente de como estão dispostos os dados da tabela de seu ERP, e entender melhor a forma que o trabalho está sendo desenvolvido.

    - ```sql
        select produto_id, qtde_vendida, data_emissao, venda_id 
        from test.venda
        where data_emissao >= '2025-02-01'
        and data_emissao < '2025-03-01'
        and produto_id = :produto_id
        limit 5```

    - As consultas principais que mostram os dados finais de interesse do cliente, seriam modificadas com linhas de parâmetro, para que o cliente possa citar algum produto específico ou fornecedor específico, para analisar a amostragem.