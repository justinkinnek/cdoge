import json
import itertools
from collections import Counter
from haversine import haversine
from sklearn.cluster import AgglomerativeClustering

DATA_PATH = 'saved_data'


def load_data():
    hits = []
    for line in open(DATA_PATH):
        if not line:
            continue
        try:
            hits.append(json.loads(line.strip()))
        except ValueError:
            continue
    d = {}
    for h in hits:
        d.update(h)
    return d


def get_follow_edges(data):
    """FB Page A likes Page B. All those edges"""
    results = []
    for id in data:
        for like_hit in  data[id].get('likes', {}).get('data', []):
            results.append((id,like_hit.get('id')))
    return results


def get_most_common_edges(edges, n):
    return Counter(map(lambda x: x[1], edges)).most_common(n)


def get_geo_coords(data):
    results = []
    for id in data:
        loc_dict = data[id].get('', {}).get('location', {})
        if loc_dict.get('latitude') and loc_dict.get('longitude'):
            results.append((id, loc_dict['latitude'], loc_dict['longitude']))
    return results

def create_sklearn_distance_matrix(data):
    hits = []
    for id_a, lat_a, long_a in data:
        row = []
        for id_b, lat_b, long_b in data:
            dist = haversine((lat_a, long_a), (lat_b, long_b))
            row.append(dist)
        hits.append(row)
    return hits


def cluster_geo_data(geo_data, n_clusters, data):
    X = create_sklearn_distance_matrix(geos)
    model = AgglomerativeClustering(n_clusters=n_clusters)
    model.fit(X)
    cols = map(lambda x: x[0], geo_data)
    cluster_list = zip(cols, model.labels_)
    # now to get city too
    hits = []
    for page_id, cluster_id in cluster_list:
        loc_dict = data[page_id].get('', {}).get('location', {})
        hits.append((cluster_id, (page_id, loc_dict.get('city'), loc_dict.get('country'), data[page_id].get('', {}).get('name'))))
    key_func = lambda x: x[0]
    hits.sort(key=key_func)
    d = {k: list(v) for k,v in itertools.groupby(hits, key=key_func)}
    return d


def generate_clusters(geo_data, data, start, end, step=10):
    results = {}
    level = 0
    previous = None
    for i in range(4):
        if previous:
            for cluster in results[previous]:
                curr_page_ids = set([t[1][0] for t in results[previous][cluster].values()])
                curr_geo_data = filter(lambda x: x[0] in curr_page_ids, geo_data)
        else:
            curr_geo_data = geo_data
            results[str(i)] = cluster_geo_data(geo_data, 4, data)
        previous = i
        level += 1
    return results


def generate_dendrogram_json(clusters):
    pass


data = load_data()
network_edges = get_follow_edges(data)
#open('influencers.txt', 'w').write(str(map(lambda x: (x[0].encode('utf-8'), x[1]), get_most_common_edges(network_edges, 50))))
geos = get_geo_coords(data)
# with open('clusters10-50.json', 'w') as f:
#     f.write(json.dumps(generate_clusters(geos, data, 10, 50)))

